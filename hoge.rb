require 'optparse'

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

def latin
    short_v = /[aiueo](?![aiueo])/
    long_v = /aa|ii|uu|ee|oo/
    diphthong = /ai|au|ei|oi|ou/
    consonant = /[^aeiou]/
    vowel = /#{short_v}|#{long_v}|#{diphthong}/
    initialSyllable = /\b(#{consonant})*#{vowel}(#{consonant})*/
    finalSyllable = /#{vowel}(#{consonant})*\b/
    medialSyllable = /\B#{vowel}#{consonant}*/

    short_vowel_reduction = [
        [/#{short_v}l/, 'ul'],
        [/#{short_v}r/, 'er']
    ]

    consonant = [
        [initialSyllable, ->(v) { p "init: #{v}"; v }],
        [medialSyllable,  ->(v) { p "med: #{v}"; v }],
        [finalSyllable, ->(v) { p "fin: #{v}"; v }]
    ]

#    p_weakning = [
#        [/p/, 'f'], [/\bf/, 'h'], [/f#{v}/, ->(w) { w.tr('f', 'w') }],
#        [/w#{not_large_v}/, ->(w) { w.tr('w', '') }]
#    ]
    consonant
end

def change(rules, word)
    rules.each { |rule| apply_rule(word, rule) }
    word
end

def repl
    loop do
        print '>'
        input = STDIN.gets.strip
        puts change(latin, input) unless input.empty?
    end
end

def sample
    'lingua latina '
end

def parse
    opt = OptionParser.new
    options = { Interactive: false, Engine: 'Japanese' }
    opt.on('-i', '--Interactive') { |v| options[:Interactive] = v }
    opt.on('-f VAL', '--File VAL') { |v| options[:File] = v }
    opt.on('-e VAL', '--Engine VAL') { |v| options[:Engine] = v }
    opt.parse ARGV
    options
end

def main
    options = parse
    if options[:Interactive]
        repl
    else
        text = options[:File] ? (File.read options[:File]) : sample
        puts change(latin, text)
    end
end

main
