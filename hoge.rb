

def apply_rule(word, rule)
    if rule[1].is_a? Proc
        word.gsub!(rule[0], &rule[1])
    else
        word.gsub!(rule[0], rule[1])
    end
end

def japanese
    v = /[aiueo]/
    not_large_v = /[iueo]/
    p_weakning = [
        [/p/, 'f'], [/\bf/, 'h'], [/f#{v}/, ->(w) { w.tr('f', 'w') }],
        [/w#{not_large_v}/, ->(w) { w.tr('w', '') }]
    ]
    vowel_fusion = [
        [/eu/, 'yo:'], [/au/, 'o:'], [/ou/, 'o:'], [/ei/, 'e:'], [/iu/, 'yu:']
    ]
    palatalization = [
        [/tu/, 'tsu'], [/du/, 'dsu'],
        [/ti/, 'chi'], [/ty/, 'ch'], [/di/, 'ji'], [/dy/, 'j'],
        [/si/, 'shi'], [/sy/, 'sh'], [/zi/, 'ji'], [/zy/, 'j']
    ]
    p_weakning + vowel_fusion + palatalization
end

def change(rules, word)
    rules.each { |rule| apply_rule(word, rule) }
    word
end

def repl
    loop do
        print '>'
        input = STDIN.gets.strip
        puts change(japanese, input) unless input.empty?
    end
end

sample = 'paru sugite natu kinikerasi sirotapeno koromo posutepu amano kaguyama'

puts sample
puts change(japanese, sample)
repl
