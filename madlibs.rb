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
  return memory[key] if memory.has_key?(key)

  STDERR.puts("Please enter a value for #{key[1..-1]}")
  value = STDIN.gets.chomp
  memory[key] = value
  value
end

filepath = ARGV.first

if filepath.nil? || filepath.empty?
  STDERR.puts("No path given")
  exit(2)
end

madlib = generate_madlib(filepath)

STDERR.puts("\nGenerated:\n====================================\n") if STDOUT.isatty
STDOUT.puts(madlib)
