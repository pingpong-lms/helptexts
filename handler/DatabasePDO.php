<?php
class DatabasePDO {

	protected $PDO;

    public function __construct($file) {
        if (!$settings = parse_ini_file($file, TRUE)) throw new exception('Unable to open ' . $file . '.');

        
        $driver = $settings['database']['driver'];
        $host = $settings['database']['host'];
        $schema = $settings['database']['schema'];
        $username = $settings['database']['username'];
        $password = $settings['database']['password'];

        $this->connection = new PDO("$driver:host=$host;dbname=$schema", $username, $password);
        $this->connection->exec('SET CHARACTER SET utf8');
    }

    private function query($sql, $inputs=array()) {
		try {
			$sth = $this->connection->prepare($sql);
			if(!$sth->execute($inputs)) {
				die($sth->errorInfo()[2]);
			}
		}
		catch(PDOException $e) {
			die($e->getMessage());
		}
		return $sth;
	}

	public function getArray($sql, $inputs=array()) {
		$result = $this->query($sql, $inputs);
		return $result->fetchAll(PDO::FETCH_ASSOC);
	}

	public function getClassArray($sql, $inputs=array(), $class) {
		$result = $this->query($sql, $inputs);
		return $result->fetchAll(PDO::FETCH_CLASS, $class);
	}

	public function getRow($sql, $inputs=array()) {
		$result = $this->query($sql, $inputs);
		return $result->fetch(PDO::FETCH_ASSOC);
	}

	public function getValue($sql, $inputs=array()) {
		$result = $this->query($sql, $inputs);
		return $result->fetchColumn();
	}
}
?>