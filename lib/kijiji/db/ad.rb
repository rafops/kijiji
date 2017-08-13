class Kijiji::DB::Ad
  TABLE = 'ads'
  KEY_ATTRIBUTES = ['postal_code_6', 'phone_number']
  REQUIRED_ATTRIBUTES = KEY_ATTRIBUTES + ['price']

  attr_reader :attributes

  def initialize(attributes)
    raise ArgumentError.new "invalid attributes" unless attributes.kind_of?(Hash)
    @attributes = attributes
  end

  def insert
    Kijiji::DB.insert(table: TABLE, attributes: attributes) if valid? and not duplicate?
  end

  def valid?
    REQUIRED_ATTRIBUTES.none? { |k| attributes[k].nil? }
  end

  def key_attributes
    Hash[KEY_ATTRIBUTES.map { |k| [k, attributes[k]] }]
  end

  def duplicate?
    Kijiji::DB.query(table: TABLE, attributes: key_attributes).any?
  end
end