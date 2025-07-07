# db/seeds.rb

# --- 1. Database Cleanup and Setup ---
puts "Dropping, creating, and migrating database..."
Rake::Task['db:drop'].invoke
Rake::Task['db:create'].invoke
Rake::Task['db:migrate'].invoke
puts "Database clean and migrated."

# --- 2. Require Faker (if not already in Gemfile) ---
# Make sure you have 'gem "faker", group: :development' in your Gemfile
# and have run 'bundle install'
require 'faker'

# --- 3. Define Constants and Helper Methods ---
PASSWORD = '123456'
CREW_COUNT = 4
OPERATORS_PER_CREW = 10
SHIFT_ENGINEERS_PER_CREW = 1

# --- USER ROLE MAPPINGS (from your provided enum) ---
# enum role: { view_only: 0, operator: 1, shift_engineer: 2, chief: 3, admin: 4 }

# Array of possible shift types
SHIFT_TYPES = ['Day Shift', 'Night Shift']

# Array of possible LogEntry types (ensure LogEntry model has this enum)
LOG_ENTRY_TYPES = LogEntry.entry_types.keys.map(&:to_sym) # Get symbols like :normal, :critical

# --- 4. Create Users ---
puts "Creating users..."

users = {} # Hash to store users by their roles/crews for easy access

# Create specific users
users[:chief] = User.find_or_create_by!(email: "ryan@email.com") do |u|
  u.password = PASSWORD
  u.password_confirmation = PASSWORD
  u.first_name = "Ryan"
  u.last_name = "Ward"
  u.role = :chief
end
puts "  Created Chief: #{users[:chief].email}"

users[:admin] = User.find_or_create_by!(email: "admin@email.com") do |u|
  u.password = PASSWORD
  u.password_confirmation = PASSWORD
  u.first_name = "Admin"
  u.last_name = "User"
  u.role = :admin
end
puts "  Created Admin: #{users[:admin].email}"

users[:view_only] = User.find_or_create_by!(email: "viewonly@email.com") do |u|
  u.password = PASSWORD
  u.password_confirmation = PASSWORD
  u.first_name = "View"
  u.last_name = "Only"
  u.role = :view_only
end
puts "  Created View Only User: #{users[:view_only].email}"

# Create Shift Engineers and Operators by crew
users[:shift_engineers] = []
users[:operators] = {}

CREW_COUNT.times do |crew_num|
  crew_name = "Crew #{crew_num + 1}"
  puts "  Creating #{crew_name} members..."

  # Shift Engineer for this crew
  se = User.find_or_create_by!(email: "se_#{crew_num + 1}@email.com") do |u|
    u.password = PASSWORD
    u.password_confirmation = PASSWORD
    u.first_name = Faker::Name.first_name
    u.last_name = Faker::Name.last_name
    u.role = :shift_engineer
  end
  users[:shift_engineers] << se
  puts "    Created Shift Engineer: #{se.email}"

  # Operators for this crew
  users[:operators][crew_name] = []
  OPERATORS_PER_CREW.times do |op_num|
    op = User.find_or_create_by!(email: "op_#{crew_num + 1}_#{op_num + 1}@email.com") do |u|
      u.password = PASSWORD
      u.password_confirmation = PASSWORD
      u.first_name = Faker::Name.first_name
      u.last_name = Faker::Name.last_name
      u.role = :operator
    end
    users[:operators][crew_name] << op
    puts "    Created Operator: #{op.email}"
  end
end
puts "All users created."

# --- 5. Create Units ---
puts "Creating units..."
units = {}
units[:cro] = Unit.find_or_create_by!(name: "CRO") do |u|
  u.description = "Control Room Operations"
end
puts "  Created Unit: #{units[:cro].name}"

units[:power_boiler] = Unit.find_or_create_by!(name: "Power Boiler") do |u|
  u.description = "Main Power Generation Boiler"
end
puts "  Created Unit: #{units[:power_boiler].name}"

units[:water_treatment] = Unit.find_or_create_by!(name: "Water Treatment") do |u|
  u.description = "Water Purification and Treatment Plant"
end
puts "  Created Unit: #{units[:water_treatment].name}"

units[:utilities] = Unit.find_or_create_by!(name: "Utilities") do |u|
  u.description = "Air Compressors, Backup Generators, Gas Turbine, Natural Gas Let Down"
end
puts "  Created Unit: #{units[:utilities].name}"

all_units_array = units.values # Get an array of all unit objects
puts "All units created."

# --- 6. Generate Logs and Log Entries with Realistic Timestamps ---
puts "Generating logs and log entries..."

start_date = 2.months.ago.to_date # Start 2 months ago
end_date = Date.today             # End today

(start_date..end_date).each do |current_date|
  puts "  Processing logs for #{current_date}..."

  # Determine log status based on date
  log_status = (current_date < 3.days.ago.to_date) ? :closed : :open

  # For each unit, create a log for the current date and both shifts
  all_units_array.each do |unit|
    SHIFT_TYPES.each do |shift_type|
      # Randomly pick a shift engineer for this log (can be any SE)
      shift_engineer = users[:shift_engineers].sample

      # Generate a random time for the log creation within the current_date
      # Day shift might be created earlier in the day, Night shift later or next morning
      log_creation_time = if shift_type == 'Day Shift'
                            Faker::Time.between(from: current_date.beginning_of_day + 6.hours, to: current_date.beginning_of_day + 18.hours)
                          else # Night Shift
                            # Can be created late at night or early next morning
                            Faker::Time.between(from: current_date.beginning_of_day + 18.hours, to: current_date.end_of_day + 6.hours)
                          end

      log = Log.create!(
        title: "#{unit.name} - #{shift_type} Log - #{current_date.strftime('%Y-%m-%d')}",
        date: current_date,
        shift_type: shift_type,
        status: log_status,
        unit: unit,
        created_at: log_creation_time, # Set created_at explicitly
        updated_at: log_creation_time  # Initially same as created_at
      )
      # puts "    Created Log: #{log.title} (Status: #{log.status})"

      # Generate 1 to 5 log entries for this log
      num_entries = rand(1..5)
      # Pick 1-3 random operators for this log's entries
      operators_for_this_log = users[:operators].values.flatten.sample(rand(1..3))

      # Track the last entry's time to ensure subsequent entries are later
      last_entry_time = log_creation_time

      num_entries.times do |i|
        # Usually same operator, but sometimes different (80% chance same as first operator)
        entry_user = (i == 0 || rand(10) < 8) ? operators_for_this_log.first : operators_for_this_log.sample

        # Ensure entry time is after the log's creation time and after the previous entry
        # and within a reasonable window (e.g., up to 12 hours after log creation, or 4 hours after last entry)
        entry_creation_time = Faker::Time.between(
          from: last_entry_time,
          to: [log_creation_time + 12.hours, current_date.end_of_day + 6.hours].min # Cap at end of day/next morning for night shift
        )
        # Ensure entry_creation_time is not in the future relative to current_date if current_date is today
        entry_creation_time = [entry_creation_time, Time.current].min if current_date == Date.today

        log_entry = LogEntry.create!(
          log: log,
          user: entry_user,
          content: Faker::Lorem.paragraph(sentence_count: rand(2..5)),
          entry_type: LOG_ENTRY_TYPES.sample,
          section_identifier: Faker::Lorem.words(number: rand(1..3)).map(&:capitalize).join(' '), # e.g., "Daily Check", "Maintenance Issue"
          created_at: entry_creation_time, # Set created_at explicitly
          updated_at: entry_creation_time  # Initially same as created_at
        )
        last_entry_time = log_entry.created_at # Update last entry time for next iteration

        # Randomly update the log's updated_at to reflect the latest entry
        log.update!(updated_at: log_entry.created_at) if log.updated_at < log_entry.created_at
      end
    end
  end
end

puts "Log and Log Entry generation complete."
puts "Seed data successfully loaded!"
