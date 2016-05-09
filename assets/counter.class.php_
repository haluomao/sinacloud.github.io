<?php

/**
 * 基于 Redis 的计数器，接口同新浪云 Counter 服务的接口。
 * 可以直接替换使用。
 *
 * 如何使用：
 * 
 *   try {
 *      $c = new Counter("redis://:密码@地址:端口")
 *   } except (Exception $e) {
 *      die_($e);
 *   }
 *
 * require本class文件，替换 **SaeCounter** 类名为 **Counter** 即可。
 */
class Counter
{

	/**
	 * 构造函数
     *
     * @param string $redis_url Redis服务器的连接字符串。
	 */
	public function __construct($redis_url)
	{
        if (!preg_match('#^redis://:(.+)@(.+):(.+)$#', $redis_url, $m)) {
            throw new Exception('Invalid redis url');
        }
        $this->hashKey = get_class($this);
        $this->redis = new Redis();
        $this->redis->connect($m[2], intval($m[3]));
        if (!$this->redis->auth($m[1])) {
            throw new Exception('Authenticate the connection failed');
        }
	}

	/**
	 * 增加一个计数器
	 *
	 * @param string $name 计数器名称
	 * @param int $value 计数器初始值，默认值为0
	 * @return bool 成功返回true，失败返回false（计数器已存在返回false）
	 */
	public function create($name, $value = 0)
	{
        if ($this->redis->hExists($this->hashKey, $name)) {
            return false;
        }
        return $this->redis->hSet($this->hashKey, $name, $value);
	}

	/**
	 * 删除一个计数器
	 *
	 * @param string $name 计数器名称
	 * @return bool 成功返回true，失败返回false（计数器不存在返回false）
	 */
	public function remove($name)
	{
        return $this->redis->hDel($this->hashKey, $name);
	}

	/**
	 * 判断一个计数器是否存在
	 *
	 * @param string $name 计数器名称
	 * @return bool 存在返回true，不存在返回false
	 */
	public function exists($name)
	{
        return $this->redis->hExists($this->hashKey, $name);
	}

	/**
	 * 获取当前应用的所有计数器数据
	 *
	 * @return array|bool 成功返回数组array，失败返回false
	 */
	public function listAll()
	{ 
        return $this->redis->hKeys($this->hashKey);
	}

	/**
	 * 获取当前应用的计数器个数
	 *
	 * @return int|bool 成功返回计数器个数，失败返回false
	 */
	public function length()
	{
        return $this->redis->hLen($this->hashKey);
	}

	/**
	 * 获取指定计数器的值
	 *
	 * @param string $name 计数器名称
	 * @return int|bool 成功返回该计数器的值，失败返回false
	 */
	public function get($name)
	{
        return $this->redis->hGet($this->hashKey, $name);
	}

	/**
	 * 重新设置指定计数器的值
	 *
	 * @param string $name 计数器名称
	 * @param int $value 计数器的值
	 * @return bool 成功返回true，失败返回false
	 */
	public function set($name, $value)
	{
        return $this->redis->hSet($this->hashKey, $name, $value);
	}

	/**
	 * 同时获取多个计数器值
	 *
	 * @param array $names 计数器名称数组，array($name1, $name2, ...)
	 * @return array|bool 成功返回关联数组，失败返回false
	 */
	public function mget($names)
	{
        return $this->redis->hMGet($this->hashKey, $names);
	}

	/**
	 * 获取当前应用所有计数器的值
	 *
	 * @return array|bool 成功返回关联数组，失败返回false
	 */
	public function getall()
	{
        return $this->redis->hGetAll($this->hashKey);
	}

	/**
	 * 对指定计数器做加法操作
	 *
	 * @param string $name 计数器名称
	 * @param int $value 计数器增加值
	 * @return int|bool 成功返回该计数器的当前值，失败返回false（计数器不存在返回false）
	 */
	public function incr($name, $value = 1)
	{
        return $this->redis->hIncrBy($this->hashKey, $name, $value);
	}

	/**
	 * 对指定计数器做减法操作
	 *
	 * @param string $name 计数器名称
	 * @param int $value 计数器减少值
	 * @return int|bool 成功返回该计数器的当前值，失败返回false（计数器不存在返回false）
	 */
	public function decr($name, $value = 1)
	{
        return $this->redis->hIncrBy($this->hashKey, $name, -$value);
	}
}
