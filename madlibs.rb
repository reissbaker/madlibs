#!/usr/bin/env ruby

def generate_madlib(path)
  lines = []
  memory = {}

  File.foreach(path) do |line|
    words = line.split(' ').map do |word|
      parse_word(memory, word)
    end
    lines << words.join(' ')
  end

  lines.join("\n")
end

def parse_word(memory, word)
  return word unless word.match(/^\$[A-z]/)

  matches = word.match(/^(\$[A-z]+)(.*)/)
  key = matches[1]
  rest = matches[2]
  "#{get_value(memory, key)}#{rest}"
end

def get_value(memory, key)
  if memory.has_key?(key)
    return memory[key]
  end

  STDERR.puts("Please enter a value for #{key[1..-1]}")
  value = STDIN.gets.chomp
  memory[key] = value
  value
end

filepath = ARGV.first
raise "No path given" if filepath.nil? || filepath.empty?

madlib = generate_madlib(filepath)

if STDOUT.isatty
  STDERR.puts("\nGenerated:\n====================================\n")
end

puts madlib
