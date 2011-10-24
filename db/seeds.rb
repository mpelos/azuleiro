# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

cities = {
  'Aracaju'                 => 'AJU',
  'Aracatuba'               => 'ARU',
  'Belém'                   => 'BEL',
  'Belo Horizonte'          => 'CNF',
  'Brasília'                => 'BSB',
  'Campinas'                => 'VCP',
  'Campo Grande'            => 'CGR',
  'Caxias do Sul'           => 'CXJ',
  'Cuiabá'                  => 'CGB',
  'Curitiba'                => 'CWB',
  'Florianópolis'           => 'FLN',
  'Fortaleza'               => 'FOR',
  'Foz do Iguaçú'           => 'IGU',
  'Goiania'                 => 'GYN',
  'Ilhéus'                  => 'IOS',
  'João Pessoa'             => 'JPA',
  'Joinville'               => 'JOI',
  'Juazeiro do Norte'       => 'JDO',
  'Juiz de Fora'            => 'IZA',
  'Maceió'                  => 'MCZ',
  'Manaus'                  => 'MAO',
  'Marília'                 => 'MII',
  'Maringá'                 => 'MGF',
  'Natal'                   => 'NAT',
  'Navegantes'              => 'NVT',
  'Palmas'                  => 'PMW',
  'Porto Alegre'            => 'POA',
  'Porto Seguro'            => 'BPS',
  'Presidente Prudente'     => 'PPB',
  'Recife'                  => 'REC',
  'Ribeirão Preto'          => 'RAO',
  'Rio de Janeiro'          => 'SDU',
  'Rio de Janeiro - Galeão' => 'GIG',
  'Salvador'                => 'SSA',
  'São José do Rio Preto'   => 'SJP',
  'São José dos Campos'     => 'SJK',
  'São Luís'                => 'SLZ',
  'São Paulo - Congonhas'   => 'CGH',
  'Teresina'                => 'THE',
  'Uberaba'                 => 'UBA',
  'Vitória'                 => 'VIX'
}

cities.each_pair do |name, code|
  City.find_or_create_by_name_and_code(name, code)
end
