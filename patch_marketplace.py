import re
import os

with open('/media/hp-ml10/Projects/bnb-edge-node/index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# I will replace the block from 
# <!-- ════ MARKETPLACE ════ -->
# to the next <!--
# Wait, let's find the exact bounds.
