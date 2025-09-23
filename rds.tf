# RDS Database
# Set up a MySQL RDS instance for WordPress.

# RDS Instance
resource "aws_db_instance" "wordpress_db" {
  identifier             = "wordpress-db"                                     # Unique identifier for the RDS instance
  allocated_storage      = 20                                                 # 20GB of storage
  storage_type           = "gp2"                                              # General Purpose SSD
  engine                 = "mysql"                                            # MySQL database engine
  engine_version         = "8.0"                                              # MySQL version 8.0
  instance_class         = "db.t3.micro"                                      # Free tier eligible instance type
  db_name                = "wordpressdb"                                      # Name of the WordPress database
  username               = var.db_username                                    # Database admin username
  password               = var.db_password                                    # Replace with a secure password
  parameter_group_name   = "default.mysql8.0"                                 # Default parameter group for MySQL 8.0
  skip_final_snapshot    = true                                               # Skip final snapshot when destroying the database
  vpc_security_group_ids = [aws_security_group.rds_sg.id]                     # Attach the RDS security group
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db_subnet_group.name # Use the created subnet group
}
