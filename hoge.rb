def change(word)
    v = /[aiueo]/
    not_large_v = /[iueo]/
    word.tr!('p', 'f')
    word.gsub!(/\bf/, 'h')
    word.gsub!(/f#{v}/) { |w| w.tr('f', 'w') }
    word.gsub!(/w#{not_large_v}/) { |w| w.tr('w', '') }
    word.gsub!(/eu/, 'yo:')
    word.gsub!(/au/, 'o:')
    word.gsub!(/ou/, 'o:')
    word.gsub!(/ei/, 'e:')
    word.gsub!(/iu/, 'yu:')
    word.gsub!(/tu/, 'tsu')
    word.gsub!(/du/, 'dsu')
    word.gsub!(/ti/, 'chi')
    word.gsub!(/ty/, 'ch')
    word.gsub!(/di/, 'ji')
    word.gsub!(/dy/, 'j')
    word.gsub!(/si/, 'shi')
    word.gsub!(/sy/, 'sh')
    word.gsub!(/zi/, 'ji')
    word.gsub!(/zy/, 'j')
    word
end

sample = 'paru sugite natu kinikerasi sirotapeno koromo posutepu amano kaguyama'

def repl
    loop do
        print '>'
        input = STDIN.gets.strip
        puts change(input) unless input.empty?
    end
end

puts sample
puts change(sample)
repl
