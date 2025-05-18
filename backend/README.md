# Lucee Framework MVC

- Create Project

```bash
mkdir my-cfml-project
cd my-cfml-project
box init name="My Lucee App" author="Your Name"
```

## panduan umrl rewrite

[Panduan Rqrewritte](https://commandbox.ortusbooks.com/embedded-server/configuring-your-server/url-rewrites)

## Tabel Schema

```sql
CREATE TABLE `personal` (
  `personal_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Create Time',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Updated Time',
  PRIMARY KEY (`personal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `uuid` varchar(255) DEFAULT NULL,
  `status` int(1) DEFAULT 0,
  `personal_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Create Time',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Updated Time',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  KEY `personal_id` (`personal_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`personal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci
```
