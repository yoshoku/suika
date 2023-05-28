# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require 'csv'
require 'dartsclone'
require 'nkf'
require 'rubygems/package'
require 'zlib'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[rubocop spec]

desc 'Build suika system dictionary'
task :dictionary do # rubocop:disable Metrics/BlockLength
  base_dir = "#{__dir__}/dict/mecab-ipadic-2.7.0-20070801"
  unless File.directory?(base_dir)
    puts "Download mecab-ipadic file and expand that under dict directory:  #{__dir__}/dict/mecab-ipadic-2.7.0-20070801"
    puts
    puts 'Example:'
    puts 'wget -O dict/mecab-ipadic.tgz https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM'
    puts 'cd dict'
    puts 'tar xzf mecab-ipadic.tgz'
    puts 'cd ../'
    next # exit
  end

  File.open("#{__dir__}/dict/mecab-ipadic-2.7.0-20070801/Reiwa.csv", 'w') do |f|
    f.puts('令和,1288,1288,5904,名詞,固有名詞,一般,*,*,*,令和,レイワ,レイワ')
  end

  unknowns = {}
  File.open("#{base_dir}/unk.def") do |f|
    f.each_line do |line|
      row = NKF.nkf('-w', line.chomp).split(',')
      unknowns[row[0]] ||= []
      unknowns[row[0]] << [row[1].to_i, row[2].to_i, row[3].to_i, *row[4..-1]]
    end
  end

  dict = {}
  Dir.glob("#{base_dir}/*.csv").each do |filename|
    File.open(filename) do |f|
      f.each_line do |line|
        row = NKF.nkf('-w', line.chomp).split(',')
        dict[row[0]] ||= []
        dict[row[0]] << [row[1].to_i, row[2].to_i, row[3].to_i, *row[4..-1]]
      end
    end
  end

  da = DartsClone::DoubleArray.new
  words = dict.keys.sort
  da.build(words)
  features = words.map { |w| dict[w] }

  concosts = nil
  File.open("#{base_dir}/matrix.def") do |f|
    n_entries = f.readline.chomp.split.map(&:to_i).first
    concosts = Array.new(n_entries) { Array.new(n_entries) }
    f.each_line do |line|
      row, col, cost = line.chomp.split.map(&:to_i)
      concosts[row][col] = cost
    end
  end

  ipadic = {
    trie: da.get_array,
    features: features,
    unknowns: unknowns,
    concosts: concosts
  }

  Zlib::GzipWriter.open("#{__dir__}/dict/sysdic.gz", Zlib::BEST_SPEED) { |f| f.write(Marshal.dump(ipadic)) }

  puts 'The system dictionary has been successfully built:'
  puts "#{__dir__}/dict/sysdic.gz"
  puts Digest::SHA1.file("#{__dir__}/dict/sysdic.gz")
end
