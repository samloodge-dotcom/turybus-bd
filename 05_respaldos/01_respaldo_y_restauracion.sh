#!/usr/bin/env bash
set -e

BACKUP_DIR="$HOME/turybus-bd/05_respaldos"
FECHA=$(date +"%Y%m%d_%H%M%S")
ARCHIVO="$BACKUP_DIR/backup_turybus_${FECHA}.sql"

# Respaldo completo de tablas, vistas, rutinas y triggers de turybus
sudo mysqldump --single-transaction --routines --triggers turybus > "$ARCHIVO"
ls -lh "$ARCHIVO"

# Verificación de restauración en una base temporal
sudo mysql -e "DROP DATABASE IF EXISTS turybus_restore_test; CREATE DATABASE turybus_restore_test;"
sudo mysql turybus_restore_test < "$ARCHIVO"
sudo mysql -e "USE turybus_restore_test; SHOW TABLES; SELECT COUNT(*) AS total_billetes FROM billete;"
sudo mysql -e "DROP DATABASE turybus_restore_test;"
