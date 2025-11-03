class RedisClientProvider {

	static client = RedisClient()


	static function getClient() {
		return RedisClientProvider.client
	}

}