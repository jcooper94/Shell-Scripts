#!/bin/sh
(crontab -l 2>/dev/null || true; echo "*/30 * * * * /downloads/transmission rmdir *") | crontab -e