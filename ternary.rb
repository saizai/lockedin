#!/usr/bin/env ruby

require 'json'

@querytime = 2
@blink1time = 1
@blink2time = 1
@blink3time = 1
@onechoicetime = 0.01
@debug = false
@log = false

@lefttime, @yestime, @righttime = @blink1time, @blink2time, @blink3time

@best_split_points = JSON.parse(File.read('best_split_points.json')) rescue {}
@frequencies = JSON.parse(File.read('frequencies.json')) rescue {}

def frequencies prefix
  return @frequencies[prefix] if @frequencies[prefix]
  nexts = File.open('bnc_words').grep(/^#{prefix}/).map do |word|
    [word.split(' ')[0][prefix.size], word.split(' ')[1].to_i]
  end
  letters = nexts.map{|a,b|a}.uniq
  freqs = {}
  letters.each{|l| freqs[l || ' '] = nexts.select{|a,b| a==l}.inject(0){|h,lf| h+lf[1]}}
  @frequencies[prefix] = freqs
end

class Array
  def sum
    self.inject(0){|a,b| a+b}
  end
end

def best_split_point_time state = '', keys = [' ', *('a'..'z')]
  return @best_split_points[[state, keys]] if @best_split_points[[state, keys]]
  return ['*', @yestime] if state[-1] == ' '

  splitpoint_times = {}
  keys = frequencies(state).keys.select{|a,b| keys.include? a}
  total_freq = frequencies(state).select{|a,b| keys.include? a}.values.sum * 1.0

  if keys.size == 1
    splitpoint = keys.first
    time = @onechoicetime + best_split_point_time(state + splitpoint)[1]
    splitpoint_times[splitpoint] = time
    puts "#{'%-18s' % state} #{'%-29s' % ('[' + keys.join + ']')} >#{splitpoint} T: #{'%.4f' % time}" if @debug
  else
    keys.each do |splitpoint|
      leftkeys = keys.select{|k| k < splitpoint}
      rightkeys = keys.select{|k| k > splitpoint}

      exacttime = @yestime + (best_split_point_time(state + splitpoint)[1]) *
                (frequencies(state)[splitpoint] / total_freq)
      lefttime = leftkeys.empty? ? 0 : @lefttime +
                    (best_split_point_time(state, leftkeys)[1] *
                     frequencies(state).select{|a,b| leftkeys.include? a}.values.sum /
                     total_freq)
      righttime = rightkeys.empty? ? 0 : @righttime +
                    (best_split_point_time(state, rightkeys)[1] *
                     frequencies(state).select{|a,b| rightkeys.include? a}.values.sum /
                     total_freq)

      time = @querytime + exacttime + lefttime + righttime
      puts "#{'%-18s' % state} #{'%-29s' % ('[' + keys.join + ']')} >#{splitpoint} T: #{'%.4f' % time} \
E: #{'%.4f' % exacttime},#{'%.4f' % (1.0 * frequencies(state)[splitpoint] / total_freq)} \
L: #{'%.4f' % lefttime},#{'%.4f' % (1.0 * leftkeys.inject(0){|h,v| h+ frequencies(state)[v]} / total_freq)} \
R: #{'%.4f' % righttime},#{'%.4f' % (1.0 * rightkeys.inject(0){|h,v| h+ frequencies(state)[v]} / total_freq)}" if @debug
      splitpoint_times[splitpoint] = time
    end
  end
  best_sp, best_time = splitpoint_times.sort{|a,b| a[1]<=>b[1]}.first
  puts "* #{'%-18s' % state} #{'%-29s' % ('[' + keys.join + ']')} >#{best_sp} T: #{'%.4f' % best_time}" if @log
  @best_split_points[[state, keys]] = [best_sp, best_time]
end

@max_lines = 5

def print_optimal state = '', keys = nil
  keys ||= frequencies(state).keys
  best = []
  while !keys.empty?
    b = best_split_point_time(state, keys)
    best << b
    keys -= [b[0]]
  end
  total_freq = best.inject(0){|h,v|h+v[1]}
  max_freq = best.map{|v|v[1]}.max
  best.sort.map{|i| "#{i[0]}" + "\u0332" * [0, [best.size, @max_lines].max - best.index(i)].max }.join
end