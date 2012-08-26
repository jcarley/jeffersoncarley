
namespace :mongo do

  desc 'Starts mongodb.'
  task :start do
    system('mongod run --config /usr/local/etc/mongod.conf >&2')
  end

end

