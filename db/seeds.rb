# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

puts "Template tasks for songs"

TemplateTask.where(name: "Determine song concept", position: 1, score: 0, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Write lyrics", position: 2, score: 2, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Write melody", position: 3, score: 2, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Write chords", position: 4, score: 3, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Obtain use license (if cover song)", position: 1, score: 0, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Arrange song", position: 5, score: 5, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Practice all parts", position: 6, score: 7, production_stage: "preproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Get studio musicians and provide parts for practice", position: 6, score: 6, production_stage: "preproduction", task_type: "song").first_or_create

TemplateTask.where(name: "Record all parts", position: 7, score: 4, production_stage: "production", task_type: "song").first_or_create

TemplateTask.where(name: "Edit/comp recorded performances", position: 8, score: 2, production_stage: "postproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Mix song", position: 9, score: 4, production_stage: "postproduction", task_type: "song").first_or_create
TemplateTask.where(name: "Master song", position: 10, score: 8, production_stage: "postproduction", task_type: "song").first_or_create

puts "Template tasks for projects"

TemplateTask.where(name: "Produce album artwork", position: 3, score: 7, production_stage: "production", task_type: "project").first_or_create
TemplateTask.where(name: "Find and decide on a studio and engineer for recording", position: 1, score: 3, production_stage: "preproduction", task_type: "project").first_or_create
TemplateTask.where(name: "Choose a mix engineer", position: 3, score: 7, production_stage: "postproduction", task_type: "project").first_or_create
TemplateTask.where(name: "Choose a mastering engineer", position: 7, score: 8, production_stage: "postproduction", task_type: "project").first_or_create
TemplateTask.where(name: "Upload final product to be distributed", position: 9, score: 9, production_stage: "postproduction", task_type: "project").first_or_create
TemplateTask.where(name: "Execute marketing plan", position: 10, score: 9, production_stage: "postproduction", task_type: "project").first_or_create
