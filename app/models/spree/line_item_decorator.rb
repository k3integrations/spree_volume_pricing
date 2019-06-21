Spree::LineItem.class_eval do
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  # the idea here is compatibility with spree_sale_products
  # trying to create a 'calculation stack' wherein the best valid price is
  # chosen for the product. This is mainly for compatibility with spree_sale_products
  #
  # Assumption here is that the volume price currency is the same as the product currency

  def copy_price
    if variant
      update_price
      self.cost_price = variant.cost_price if cost_price.nil?
      self.currency = variant.currency if currency.nil?
    end
  end

  def update_price
    return unless variant
    vprice = variant.volume_price(quantity, order.user)
    self.price = vprice if price.nil? || vprice <= variant.price
  end
end
