
const mState = {
    providers: [
        { id: '0x7F3A...2B91', name: 'Kerala Node', loc: 'Kerala, India', emoji: '🇮🇳', gpu: 'RTX 4090', vram: '24 GB', cpu: '32 cores', ram: '64 GB', bw: '1 Gbps', rep: 94, staked: '12,450', uptime: 99.2, price: 0.005, jobs: 142, available: true, bg: 'linear-gradient(135deg,#7c3aed,#06b6d4)' },
        { id: '0xA1B2...C3D4', name: 'GPU Hub', loc: 'Frankfurt, Germany', emoji: '🇩🇪', gpu: 'A100', vram: '40 GB', cpu: '64 cores', ram: '128 GB', bw: '2 Gbps', rep: 88, staked: '8,500', uptime: 98.2, price: 0.008, jobs: 84, available: true, bg: 'linear-gradient(135deg,#059669,#06b6d4)' },
        { id: '0x9C0D...E1F2', name: 'SG Compute', loc: 'Singapore', emoji: '🇸🇬', gpu: 'H100', vram: '80 GB', cpu: '96 cores', ram: '256 GB', bw: '10 Gbps', rep: 97, staked: '21,000', uptime: 99.8, price: 0.012, jobs: 203, available: true, bg: 'linear-gradient(135deg,#d97706,#dc2626)' }
    ],
    jobs: [
        { id: '#JOB-2847', title: 'LLM Inference LLaMA 70B', status: 'running', escrowed: '$12.00' },
        { id: '#JOB-2848', title: 'Stable Diffusion batch', status: 'assigned', escrowed: '$8.50' }
    ],
    streams: [
        { id: '#STR-21983', provider: 'Kerala Node', rate: 0.005, earned: 1.24, status: 'active' }
    ],
    earnings: { total: 847.20, pending: 42.80 },
    blockNum: 8841293,
    tickerItems: [
        { l: 'BNB', v: '$584', d: 'up', c: '+2.1%' },
        { l: 'USDC', v: '$1.00', d: 'up', c: 'stable' },
        { l: 'opBNB Gas', v: '$0.001', d: 'up', c: '' },
        { l: 'Vol 24h', v: '$84.2K', d: 'up', c: '+18%' }
    ]
};

function sm(id, el) {
    document.querySelectorAll('.m-page').forEach(p => p.style.display = 'none');
    document.getElementById(id).style.display = 'block';
    document.querySelectorAll('.nav-m .nv').forEach(n => n.classList.remove('on'));
    if (el) el.classList.add('on');
    if (id === 'm-marketplace') renderProvidersM();
    if (id === 'm-jobs') renderJobsM();
    if (id === 'm-streams') renderStreamsM();
    if (id === 'm-earnings') renderChartM();
}

function renderProvidersM(data = mState.providers) {
    const grid = document.getElementById('provider-grid-m');
    if (!grid) return;
    grid.innerHTML = '';
    data.forEach(p => {
        grid.innerHTML += `
        <div class="pcard-m">
          <div style="display:flex;gap:11px;margin-bottom:14px;">
            <div style="width:44px;height:44px;border-radius:12px;background:${p.bg};display:flex;align-items:center;justify-content:center;font-size:20px;">${p.emoji}</div>
            <div style="flex:1;">
              <div style="font:700 15px/1.2 var(--d);">${p.name}</div>
              <div style="font:400 10px/1 var(--m);color:var(--cyan2);">${p.id}</div>
            </div>
            <div style="width:10px;height:10px;border-radius:50%;background:var(--grn2);box-shadow:0 0 9px var(--grn);"></div>
          </div>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:7px;margin-bottom:14px;">
            <div class="spec-box-m"><div style="font:400 9px/1 var(--m);color:var(--tx2);">GPU</div><div style="font:700 12px/1 var(--f);">${p.gpu}</div></div>
            <div class="spec-box-m"><div style="font:400 9px/1 var(--m);color:var(--tx2);">VRAM</div><div style="font:700 12px/1 var(--f);">${p.vram}</div></div>
          </div>
          <div style="display:flex;justify-content:space-between;font:700 11px/1 var(--m);">${p.rep}/100</div>
          <div style="height:4px;background:var(--sur);border-radius:100px;margin:5px 0 12px;"><div style="height:100%;width:${p.rep}%;background:var(--grn);"></div></div>
          <div class="price-row-m">
            <div><div style="font:800 16px/1 var(--d);color:var(--grn2);">$${p.price}</div><div style="font:400 9px/1 var(--m);color:var(--tx2);">per second</div></div>
            <div style="text-align:right;"><div style="font:700 12px/1 var(--m);color:var(--acc2);">${p.staked}</div><div style="font:400 9px/1 var(--f);color:var(--tx2);">Staked</div></div>
          </div>
          <div style="display:flex;gap:8px;">
            <button class="tbtn" style="flex:1; padding:8px; background:var(--acc); color:#fff; border:none; font-weight:700;" onclick="hireProvider('${p.id}')">⚙️ Hire</button>
            <button class="tbtn" style="flex:1; padding:8px; border:1px solid var(--bdr);" onclick="streamProvider('${p.id}')">▶️ Stream</button>
          </div>
        </div>`;
    });
    document.getElementById('filt-count-m').innerText = data.length + ' providers';
}

function renderJobsM() {
    const tb = document.getElementById('jobs-tbody-m');
    if (!tb) return;
    tb.innerHTML = '';
    mState.jobs.forEach(j => {
        tb.innerHTML += `<tr>
        <td style="padding:12px; font-family:var(--m); color:var(--acc2);">${j.id}</td>
        <td style="padding:12px;">${j.title}</td>
        <td style="padding:12px;"><span class="status-m" style="background:rgba(16,185,129,0.1); color:var(--grn2);">${j.status}</span></td>
        <td style="padding:12px; font-family:var(--m); color:var(--grn2);">${j.escrowed}</td>
        <td style="padding:12px;"><button class="tbtn" style="padding:4px 8px; font-size:10px;" onclick="toast('ℹ️','Job','Details for ${j.id}')">Details</button></td>
      </tr>`;
    });
}

function renderStreamsM() {
    const tb = document.getElementById('streams-tbody-m');
    if (!tb) return;
    tb.innerHTML = '';
    mState.streams.forEach(s => {
        tb.innerHTML += `<tr>
        <td style="padding:12px; font-family:var(--m); color:var(--cyan2);">${s.id}</td>
        <td style="padding:12px;">$${s.rate}/s</td>
        <td style="padding:12px; font-weight:700; color:var(--grn2);">$${s.earned}</td>
        <td style="padding:12px;"><span class="status-m" style="background:rgba(6,182,212,0.1); color:var(--cyan2);">${s.status}</span></td>
        <td style="padding:12px;"><button class="tbtn" style="padding:4px 8px; font-size:10px; background:var(--red); color:#fff; border:none;" onclick="toast('⏹️','Stream','Stopped')">Stop</button></td>
      </tr>`;
    });
}

function renderChartM() {
    const wrap = document.getElementById('earn-chart-m');
    if (!wrap) return;
    wrap.innerHTML = '';
    [18, 22, 19, 28, 31, 25, 34, 29, 36, 38, 27, 41, 35, 44, 38, 47, 42, 51, 45, 54].forEach(v => {
        const col = document.createElement('div');
        col.className = 'chart-col-m';
        col.innerHTML = `<div class="chart-bar-m" style="height:${v}%"></div>`;
        wrap.appendChild(col);
    });
}

function filterProvidersM() {
    const gpu = document.getElementById('filt-gpu-m').value;
    const s = mState.providers.filter(p => gpu ? p.gpu.includes(gpu) : true);
    renderProvidersM(s);
}

function renderTickerM() {
    const tickerInner = document.getElementById('ticker-inner');
    if (tickerInner) {
        tickerInner.innerHTML = mState.tickerItems.map(i => `
        <div class="ticker-item">
          <span class="ticker-label">${i.l}</span>
          <span>${i.v}</span>
          <span style="color:var(--grn2)">${i.c}</span>
        </div>`).join('');
    }
}

// Update on Load
document.addEventListener('DOMContentLoaded', () => {
    renderTickerM();
    renderProvidersM();
});
