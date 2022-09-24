"""
django等待数据库运行
"""
import time

from psycopg2 import OperationalError as Psycopg2OpError

from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """等待数据库连接"""
    
    def handle(self, *args, **options):
        self.stdout.write('...正在等待数据库完成启动...')
        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write('...数据库不可用,等待数据库连接成功...')
                time.sleep(1)
            
        self.stdout.write(self.style.SUCCESS('成功检测到数据库!'))