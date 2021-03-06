# rubocop:disable all
class Prefecture
  ROWS = {
    '01'.freeze => '北海道'.freeze,
    '02'.freeze => '青森県'.freeze,
    '03'.freeze => '岩手県'.freeze,
    '04'.freeze => '宮城県'.freeze,
    '05'.freeze => '秋田県'.freeze,
    '06'.freeze => '山形県'.freeze,
    '07'.freeze => '福島県'.freeze,
    '08'.freeze => '茨城県'.freeze,
    '09'.freeze => '栃木県'.freeze,
    '10'.freeze => '群馬県'.freeze,
    '11'.freeze => '埼玉県'.freeze,
    '12'.freeze => '千葉県'.freeze,
    '13'.freeze => '東京都'.freeze,
    '14'.freeze => '神奈川県'.freeze,
    '15'.freeze => '新潟県'.freeze,
    '16'.freeze => '富山県'.freeze,
    '17'.freeze => '石川県'.freeze,
    '18'.freeze => '福井県'.freeze,
    '19'.freeze => '山梨県'.freeze,
    '20'.freeze => '長野県'.freeze,
    '21'.freeze => '岐阜県'.freeze,
    '22'.freeze => '静岡県'.freeze,
    '23'.freeze => '愛知県'.freeze,
    '24'.freeze => '三重県'.freeze,
    '25'.freeze => '滋賀県'.freeze,
    '26'.freeze => '京都府'.freeze,
    '27'.freeze => '大阪府'.freeze,
    '28'.freeze => '兵庫県'.freeze,
    '29'.freeze => '奈良県'.freeze,
    '30'.freeze => '和歌山県'.freeze,
    '31'.freeze => '鳥取県'.freeze,
    '32'.freeze => '島根県'.freeze,
    '33'.freeze => '岡山県'.freeze,
    '34'.freeze => '広島県'.freeze,
    '35'.freeze => '山口県'.freeze,
    '36'.freeze => '徳島県'.freeze,
    '37'.freeze => '香川県'.freeze,
    '38'.freeze => '愛媛県'.freeze,
    '39'.freeze => '高知県'.freeze,
    '40'.freeze => '福岡県'.freeze,
    '41'.freeze => '佐賀県'.freeze,
    '42'.freeze => '長崎県'.freeze,
    '43'.freeze => '熊本県'.freeze,
    '44'.freeze => '大分県'.freeze,
    '45'.freeze => '宮崎県'.freeze,
    '46'.freeze => '鹿児島県'.freeze,
    '47'.freeze => '沖縄県'.freeze
  }.freeze

  ROW2 = {
    hokkaido: { code: '01', name: '北海道' },
    aomori: { code: '02', name: '青森県' },
    iwate: { code: '03', name: '岩手県' },
    miyagi: { code: '04', name: '宮城県' },
    akita: { code: '05', name: '秋田県' },
    yamagata: { code: '06', name: '山形県' },
    fukushima: { code: '07', name: '福島県' },
    ibaraki: { code: '08', name: '茨城県' },
    tochigi: { code: '09', name: '栃木県' },
    gunma: { code: '10', name: '群馬県' },
    saitama: { code: '11', name: '埼玉県' },
    chiba: { code: '12', name: '千葉県' },
    tokyo: { code: '13', name: '東京都' },
    kanagawa: { code: '14', name: '神奈川県' },
    niigata: { code: '15', name: '新潟県' },
    toyama: { code: '16', name: '富山県' },
    ishikawa: { code: '17', name: '石川県' },
    fukui: { code: '18', name: '福井県' },
    yamanashi: { code: '19', name: '山梨県' },
    nagano: { code: '20', name: '長野県' },
    gifu: { code: '21', name: '岐阜県' },
    shizuoka: { code: '22', name: '静岡県' },
    aichi: { code: '23', name: '愛知県' },
    mie: { code: '24', name: '三重県' },
    shiga: { code: '25', name: '滋賀県' },
    kyoto: { code: '26', name: '京都府' },
    osaka: { code: '27', name: '大阪府' },
    hyogo: { code: '28', name: '兵庫県' },
    nara: { code: '29', name: '奈良県' },
    wakayama: { code: '30', name: '和歌山県' },
    totori: { code: '31', name: '鳥取県' },
    shimane: { code: '32', name: '島根県' },
    okayama: { code: '33', name: '岡山県' },
    hiroshima: { code: '34', name: '広島県' },
    yamaguchi: { code: '35', name: '山口県' },
    tokushima: { code: '36', name: '徳島県' },
    kagawa: { code: '37', name: '香川県' },
    ehime: { code: '38', name: '愛媛県' },
    kochi: { code: '39', name: '高知県' },
    fukuoka: { code: '40', name: '福岡県' },
    saga: { code: '41', name: '佐賀県' },
    nagasaki: { code: '42', name: '長崎県' },
    kumamoto: { code: '43', name: '熊本県' },
    oita: { code: '44', name: '大分県' },
    miyazaki: { code: '45', name: '宮崎県' },
    kagoshima: { code: '46', name: '鹿児島県' },
    okinawa: { code: '47', name: '沖縄県' }
  }.freeze

  def self.options
    options = []
    ROWS.each do |k, v|
      options << [v, k]
    end
    options
  end

  def self.name(key)
    ROWS[key]
  end
end
# rubocop:enable all
