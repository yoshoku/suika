# frozen_string_literal: true

module Suika
  # @!visibility private
  class CharDef
    # @!visibility private
    def self.char_type(ch)
      code = ch.unpack1('U*')
      CHAR_TYPES.find do |ctype|
        Object.const_get("CharDef::#{ctype}").any? { |r| r.include?(code) }
      end
    end

    # @!visibility private
    def self.char_category(ch)
      CHAR_CATEGORY[char_type(ch)]
    end

    CHAR_CATEGORY = {
      'DEFAULT' => {
        invoke: 0, group: 1, length: 0
      },
      'SPACE' => {
        invoke: 0, group: 1, length: 0
      },
      'KANJI' => {
        invoke: 0, group: 0, length: 2
      },
      'SYMBOL' => {
        invoke: 1, group: 1, length: 0
      },
      'NUMERIC' => {
        invoke: 1, group: 1, length: 0
      },
      'ALPHA' => {
        invoke: 1, group: 1, length: 0
      },
      'HIRAGANA' => {
        invoke: 0, group: 1, length: 2
      },
      'KATAKANA' => {
        invoke: 1, group: 1, length: 2
      },
      'KANJINUMERIC' => {
        invoke: 1, group: 1, length: 0
      },
      'GREEK' => {
        invoke: 1, group: 1, length: 0
      },
      'CYRILLIC' => {
        invoke: 1, group: 1, length: 0
      }
    }.freeze

    CHAR_TYPES = %w[
      SPACE
      NUMERIC
      SYMBOL
      ALPHA
      CYRILLIC
      GREEK
      HIRAGANA
      KATAKANA
      KANJI
      KANJINUMERIC
    ].freeze

    SPACE = [
      0x0020..0x0020,
      0x00D0..0x00D0,
      0x0009..0x0009,
      0x000B..0x000B,
      0x000A..0x000A
    ].freeze

    NUMERIC = [
      0x0030..0x0039,  # ASCII
      0xFF10..0xFF19,  # ZENKAKU
      # OTHER SYMBOLS
      0x2070..0x209F,  # Superscripts and Subscripts
      0x2150..0x218F   # Number forms
    ].freeze

    SYMBOL = [
      # ASCII
      0x0021..0x002F,
      0x003A..0x0040,
      0x005B..0x0060,
      0x007B..0x007E,
      # Latin 1
      0x00A1..0x00BF,
      # ZENKAKU
      0xFF01..0xFF0F,
      0xFF1A..0xFF1F,
      0xFF3B..0xFF40,
      0xFF5B..0xFF65,
      0xFFE0..0xFFEF, # HalfWidth and Full width Form
      # OTHER SYMBOLS
      0x2000..0x206F,  # General Punctuation
      0x20A0..0x20CF,  # Currency Symbols
      0x20D0..0x20FF,  # Combining Diaritical Marks for Symbols
      0x2100..0x214F,  # Letterlike Symbols
      0x2100..0x214B,  # Letterlike Symbols
      0x2190..0x21FF,  # Arrow
      0x2200..0x22FF,  # Mathematical Operators
      0x2300..0x23FF,  # Miscellaneuos Technical
      0x2460..0x24FF,  # Enclosed NUMERICs
      0x2501..0x257F,  # Box Drawing
      0x2580..0x259F,  # Block Elements
      0x25A0..0x25FF,  # Geometric Shapes
      0x2600..0x26FE,  # Miscellaneous Symbols
      0x2700..0x27BF,  # Dingbats
      0x27F0..0x27FF,  # Supplemental Arrows A
      0x27C0..0x27EF,  # Miscellaneous Mathematical Symbols-A
      0x2800..0x28FF,  # Braille Patterns
      0x2900..0x297F,  # Supplemental Arrows B
      0x2B00..0x2BFF,  # Miscellaneous Symbols and Arrows
      0x2A00..0x2AFF,  # Supplemental Mathematical Operators
      0x3300..0x33FF,
      0x3200..0x32FE,  # ENclosed CJK Letters and Months
      0x3000..0x303F,  # CJK Symbol and Punctuation
      0xFE30..0xFE4F,  # CJK Compatibility Forms
      0xFE50..0xFE6B,  # Small Form Variants
      # 0x3007 SYMBOL KANJINUMERIC
      0x3007..0x3007
    ].freeze

    ALPHA = [
      # ASCII
      0x0041..0x005A,
      0x0061..0x007A,
      # Latin
      0x00C0..0x00FF,   # Latin 1
      0x0100..0x017F,   # Latin Extended A
      0x0180..0x0236,   # Latin Extended B
      0x1E00..0x1EF9,   # Latin Extended Additional
      0xFF21..0xFF3A,   # ZENKAKU
      0xFF41..0xFF5A    # ZENKAKU
    ].freeze

    # CYRILLIC
    CYRILLIC = [
      0x0400..0x04F9,
      0x0500..0x050F # Cyrillic supplementary
    ].freeze

    # GREEK
    GREEK = [0x0374..0x03FB].freeze # Greek and Coptic

    # HIRAGANA
    HIRAGANA = [0x3041..0x309F].freeze

    # KATAKANA
    KATAKANA = [
      0x30A1..0x30FF,
      0x31F0..0x31FF, # Small KU .. Small RO
      0x30FC..0x30FC,
      # Half KATAKANA
      0xFF66..0xFF9D,
      0xFF9E..0xFF9F
    ].freeze

    # KANJI
    KANJI = [
      0x2E80..0x2EF3,   # CJK Raidcals Supplement
      0x2F00..0x2FD5,
      0x3005..0x3005,
      0x3007..0x3007,
      0x3400..0x4DB5,   # CJK Unified Ideographs Extention
      0x4E00..0x9FA5,
      0xF900..0xFA2D,
      0xFA30..0xFA6A
    ].freeze

    # rubocop:disable Style/AsciiComments
    # KANJI-NUMERIC （一 二 三 四 五 六 七 八 九 十 百 千 万 億 兆）
    # 0x4E00 KANJINUMERIC KANJI
    KANJINUMERIC = [
      0x4E00..0x4E00,
      0x4E8C..0x4E8C,
      0x4E09..0x4E09,
      0x56DB..0x56DB,
      0x4E94..0x4E94,
      0x516D..0x516D,
      0x4E03..0x4E03,
      0x516B..0x516B,
      0x4E5D..0x4E5D,
      0x5341..0x5341,
      0x767E..0x767E,
      0x5343..0x5343,
      0x4E07..0x4E07,
      0x5104..0x5104,
      0x5146..0x5146
    ].freeze
    # rubocop:enable Style/AsciiComments

    private_constant :CHAR_CATEGORY, :CHAR_TYPES

    private_constant :ALPHA, :CYRILLIC, :GREEK, :HIRAGANA, :KANJI, :KANJINUMERIC, :KATAKANA, :NUMERIC, :SPACE, :SYMBOL
  end
end
