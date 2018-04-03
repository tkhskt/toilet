docker-init:
	docker-compose build && docker-compose run web bundle exec rails db:create db:migrate db:seed
