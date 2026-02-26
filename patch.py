import re

with open('/media/hp-ml10/Projects/bnb-edge-node/index.html', 'r', encoding='utf-8') as f:
    html = f.read()

with open('/media/hp-ml10/Projects/bnb-edge-node/m-styles.css', 'r', encoding='utf-8') as f:
    m_styles = f.read()

with open('/media/hp-ml10/Projects/bnb-edge-node/m-html.html', 'r', encoding='utf-8') as f:
    m_html = f.read()

with open('/media/hp-ml10/Projects/bnb-edge-node/m-js.js', 'r', encoding='utf-8') as f:
    m_js = f.read()

# 1. Add font
font_link = '<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800;900&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600;9..40,700&family=DM+Mono:wght@400;500;600&display=swap" rel="stylesheet">'
html = html.replace('<link', font_link + '\n  <link', 1)

# 2. Add styles before </style>
html = html.replace('  </style>', m_styles + '\n  </style>')

# 3. Replace marketplace div content
# Find the start and end of <div class="pg" id="marketplace"> ... </div>
# We know it's around 2703 to 2752
start_tag = '<div class="pg" id="marketplace">'
end_tag = '</div>'

# We need to find the correct </div>. Since it's nested, we look for the next <div class="pg" id="agents">
next_div = '<div class="pg" id="agents">'
marketplace_start = html.find(start_tag)
agents_start = html.find(next_div)

# The marketplace section is between marketplace_start and agents_start
# We want to keep <div class="pg" id="marketplace"> and replace its inner content.
# Actually, let's find the closing </div> of the marketplace div before agents_start.

sub_content = html[marketplace_start:agents_start]
# The last </div> in sub_content corresponds to the closing of marketplace pg
last_div_idx = sub_content.rfind('</div>')
m_outer_start = marketplace_start
m_outer_end = marketplace_start + last_div_idx + 6 # plus length of </div>

# Replace inner content
new_m_div = '<div class="pg" id="marketplace">\n' + m_html + '\n    </div>'
html = html[:m_outer_start] + new_m_div + html[m_outer_end:]

# 4. Add JS logic
# Add before </script>
html = html.replace('    </script>', m_js + '\n    </script>')

# 5. Update sw function to trigger sm('m-overview')
old_sw = 'document.getElementById(id).classList.add(\'active\'); if (b) b.classList.add(\'active\');'
new_sw = old_sw + " if(id === 'marketplace') sm('m-overview', document.querySelector('.nav-m .nv'));"
html = html.replace(old_sw, new_sw)

with open('/media/hp-ml10/Projects/bnb-edge-node/index.html', 'w', encoding='utf-8') as f:
    f.write(html)

print("Patch applied successfully.")
