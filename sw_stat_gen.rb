## Prints out rolling stats for Savage Worlds
## Author: Lemtzas
## Sample usage: print_all_stats_wc() ; $stdout.flush
##               print_all_stats_wc(6); $stdout.flush
##               print_all_stats()    ; $stdout.flush

# Prints out stats for all TNs from 1 to 20;
# Intended for wildcards - wd is the wild die size to use; will use d6 if omitted
# Percentages are returned in "At least" format"
def print_all_stats_wc(wd=6)
  #tns = [2,4,6,8,10,12]
  #tns.each do |tn|
  (1..20).each do |tn|
    print_stats(tn,wd)
  end
  $stdout.flush
end

# Prints out stats for all TNs from 1 to 20;
# Calculates raw stats without a wild die
# Percentages are returned in "At least" format"
def print_all_stats()
  #tns = [2,4,6,8,10,12]
  #tns.each do |tn|
  (1..20).each do |tn|
    print_stats(tn,nil)
  end
  $stdout.flush
end

def print_stats(tn,wild_die=nil)
  wd = nil
  wd = gen_stats(wild_die,tn) if wild_die
  x = gen_all_tn(tn,wd)
  print "Die\t\tpass\traise\traise2\traise3\t...\tfor tn #{tn}";
  if wild_die
    puts " w/ Wild Die d#{wild_die}"
  else
    puts " w/o Wild Die"
  end

  x.each{|x,y|
    puts "#{x}\t\t#{y.join(" \t")}\n"
  }
end

def gen_all_tn(tn,wd=nil)
  dice = {4=>nil,
          6=>nil,
          8=>nil,
          10=>nil,
          12=>nil}
  dice.each do |x,y|
    dice[x] = gen_stats(x,tn,wd)
  end
  dice
end

def gen_stats(die, tn,wd=nil)
  probabilities = Array.new
  raises = 0
  last_prob = num_or_higher(die,tn)
  probabilities.push(calc_actual_prob(last_prob,raises,wd))
  while(last_prob >= 0.01)
    raises = raises + 1
    tn = tn + 4
    last_prob = num_or_higher(die,tn)
    probabilities.push(calc_actual_prob(last_prob,raises,wd))
  end
  probabilities
end

def num_or_higher(die,num)
  if num <= die
    return (die-(num-1.0)) / die
  else
    return (1.0/die) * num_or_higher(die,num-die)
  end
end

def calc_actual_prob(prob,raises,wd=nil)
  if wd
    if wd[raises]
      wd_prob = wd[raises]/100.0
    else
      wd_prob = 0
    end
    prob = 1.00-(1.00-prob)*(1.00-wd_prob)
  else
  end
  rounded_prob = (prob * 100.0).round(2)
  rounded_prob
end