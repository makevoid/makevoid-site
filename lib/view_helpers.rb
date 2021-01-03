module ViewHelpers
  # def labelize(string)
  #   Inflecto.humanize(Inflecto.underscore(string.to_s)).capitalize
  # end

  def prettify_title(title)
    upcase_keywords Inflecto.humanize(Inflecto.underscore title.to_s).capitalize
  end

  UPCASE_KEYWORDS = %w(
    cli json haml html css ws eth btc ipfs vesc
  )

  UPCASE_KEYWORDS_BOUNDARY = %w(
    cc em ui
  )

  CAPITALIZE_KEYWORDS = %w(
    sass web3 roda ethereum bapp bitcoin dogecoin litecoin docker inesita geth solc clearwater packt transifex unbound clef bulma kovan rinkeby unity ruby twilio redux rollup bitcore
  )

  CAPITALIZE_KEYWORDS_BOUNDARY = %w(
    go
  )

  def upcase_keywords(title)
    UPCASE_KEYWORDS.each do |keyword|
      title.gsub!(/#{keyword}/i, keyword.upcase)
    end

    UPCASE_KEYWORDS_BOUNDARY.each do |keyword|
      title.gsub!(/ #{keyword}/i, " #{keyword.upcase}")
      title.gsub!(/#{keyword} /i, "#{keyword.upcase} ")
    end

    CAPITALIZE_KEYWORDS.each do |keyword|
      title.gsub!(/#{keyword}/i, keyword.capitalize)
    end

    CAPITALIZE_KEYWORDS_BOUNDARY.each do |keyword|
      title.gsub!(/ #{keyword}/i, " #{keyword.capitalize}")
      title.gsub!(/#{keyword} /i, "#{keyword.capitalize} ")
    end

    # exceptions
    title.gsub! /thegrid/i,  "TheGrid"
    title.gsub! /tlsnotary/i,  "TlsNotary"

    # fixes
    title.gsub! /client/i,   "client"

    title
  end

end
