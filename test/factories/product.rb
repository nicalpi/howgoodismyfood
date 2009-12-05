Factory.define :product do |u|
  u.name            "Biscuit"
  u.energy          2114
  u.portion         28
  u.protein         7.6
  u.carbohydrate    60
  u.sugar           40
  u.fat             26
  u.saturate        16
  u.fibre           2.4
  u.sodium          0.24
  u.added_sugar     30
  u.kind            "food"
  u.sequence(:barcode) {|n| "401710029000#{n}" }
end
