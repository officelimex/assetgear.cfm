<style>
	table .matrix {
		width: 100%;
		border-collapse: collapse;
		margin-bottom: 20px;
	}
	.matrix th,
	.matrix td {
		border: 1px solid gray;
		padding: 8px;
		text-align: center;
	}
	.rotate-text {
		writing-mode: vertical-rl;
		transform: rotate(180deg);
		white-space: nowrap;
	}
	.very-high {
		background-color: #ff4d4d;
		color: white;
	}
	.high {
		background-color: #ff944d;
		color: black;
		font-weight: bold;
	}
	.vh,
	.h,
	.l,
	.m {
		font-weight: bold;
		text-transform: uppercase;
	}
	.vh {
		background-color: #ff0000;
		color: white;
	}
	.h {
		background-color: #ff3902de;
		color: white;
		font-weight: bold;
	}
	.m {
		background-color: #ffcc00;
		color: black;
		font-weight: bold;
	}
	.l {
		background-color: #99cc99;
		color: black;
		font-weight: bold;
	}
	.bl-none {
		border-left: none !important;
	}
	.br-none {
		border-right: none !important;
	}
	.bt-none {
		border-top: none !important;
	}
	.bb-none {
		border-bottom: none !important;
	}
	.medium {
		background-color: #ffcc00;
		color: black;
	}
	.low {
		background-color: #99cc99;
		color: black;
	}
	.hdb1 {
		background-color: #eae3c6;
		font-weight: bold;
	}
	.hdb2 {
		background-color: #f2c8ec;
		font-weight: bold;
	}
	.risk-matrix-header {
		font-weight: bold;
		background-color: #bfbfbf;
	}
	td ul li,
	td ol li {
		list-style-type: disc;
		padding: 0;
		margin: 0;
		margin-left: 20px;
	}
	td ol li {
		list-style-type: decimal;
	}
	td ul,
	td ol {
		text-align: left;
		padding: 0;
		margin: 0;
	}
	.text-center{text-align:center;}
	.info {
		background-color: #d7ddf3;
	}
</style>
<h3 class="text-center">RISK MATRIX</h3>

<table class="matrix">
	<thead>
		<tr>
			<th colspan="2" rowspan="2" class="bl-none bt-none"></th>
			<th class="text-center hdb1" colspan="5">SEVERITY OF CONSEQUENCES</th>
			<th class="br-none bt-none"></th>
		</tr>
		<tr>
			<th>
				CATASTROPHIC<br />
				(5)
			</th>
			<th>MAJOR<br />(4)</th>
			<th>SERIOUS<br />(3)</th>
			<th>MINOR<br />(2)</th>
			<th>
				INSIGNIFICANT<br />
				(1)
			</th>
			<th>Working Definitions</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="rotate-text hdb2" rowspan="5">LIKELIHOOD</td>
			<td class="info">FREQUENT <br />(5)</td>
			<td class="vh">VERY HIGH</td>
			<td class="vh">VERY HIGH</td>
			<td class="h">HIGH</td>
			<td class="m">M</td>
			<td class="m">M</td>
			<td class="info">More than 3 times per year</td>
		</tr>
		<tr>
			<td class="info">OCCASIONAL <br />(4)</td>
			<td class="vh">VERY HIGH</td>
			<td class="h">HIGH</td>
			<td class="m">M</td>
			<td class="m">M</td>
			<td class="l">L</td>
			<td class="info">twice Per year</td>
		</tr>
		<tr>
			<td class="info">SELDOM <br />(3)</td>
			<td class="h">HIGH</td>
			<td class="m">M</td>
			<td class="m">M</td>
			<td class="m">M</td>
			<td class="l">L</td>
			<td class="info">Once Per year</td>
		</tr>
		<tr>
			<td class="info">UNLIKELY <br /(2)</td>
			<td class="m">M</td>
			<td class="m">M</td>
			<td class="l">L</td>
			<td class="l">L</td>
			<td class="l">L</td>
			<td class="info">Rare, once in 5 years</td>
		</tr>
		<tr>
			<td class="info">REMOTE <br />(1)</td>
			<td class="m">m</td>
			<td class="l">l</td>
			<td class="l">l</td>
			<td class="l">l</td>
			<td class="l">l</td>
			<td class="info">Very Rare, Once in 25 years</td>
		</tr>
		<tr>
			<td class="bl-none bb-none" colspan="2"></td>
			<td class="" valign="top">
				<ul>
					<li>3+ Fatalities</li>
					<li>Higher than $1m Damage</li>
					<li>Persistent, Severe pollution, damage and Long term effects</li>
					<li>Severe Embarrassment or Damage, Litigation</li>
				</ul>
			</td>
			<td class="" valign="top">
				<ul>
					<li>Up to 3 Fatalities</li>
					<li>Up to $1M Damage</li>
					<li>extensive offsite contamination, Long Term Effects</li>
					<li>Major damage, National Coverage</li>
				</ul>
			</td>
			<td class="" valign="top">
				<ul>
					<li>Serious Injury, LTI, &les;5 Days</li>
					<li>Up to $100K Damage</li>
					<li>Offsite Env. Cont/ G-Water Cont, Vegetation impact</li>
					<li>Local Coverage, Serious response</li>
				</ul>
			</td>
			<td class="" valign="top">
				<ul>
					<li>Minor injury, Disability, LTI,</li>
					<li>Up to 10K Damage/Loss</li>
					<li>Minor env. Impact. Local Spill, G-water Cont.</li>
					<li>Minor Impairment</li>
				</ul>
			</td>
			<td class="" valign="top">
				<ul>
					<li>No Injury/ No Health Effect,</li>
					<li><$1K Damage or None</li>
					<li>Negligible Envr. Impact. Contained within Location</li>
					<li>Negligible</li>
				</ul>
			</td>
			<td class="" valign="top">
				Working Definitions for CONSEQUENCE Severity
				<ol>
					<li>Personnel</li>
					<li>Financial</li>
					<li>Environmental</li>
					<li>Reputation</li>
				</ol>
			</td>
		</tr>
	</tbody>
</table>

<div class="row-fluid">
	<div class="span7">
		<h3>Risk Ratings & Actions</h3>
		<table class="matrix">
			<tr>
				<th class="risk-matrix-header">Risk Class</th>
				<th class="risk-matrix-header">Risk Rating</th>
				<th class="risk-matrix-header">Action to be taken</th>
			</tr>
			<tr>
				<td class="vh">Very High</td>
				<td>25 to 20</td>
				<td>
					Task must not proceed. Redefine or implement further control measures.
				</td>
			</tr>
			<tr>
				<td class="h">High</td>
				<td>16 to 15</td>
				<td>Stop the work. Immediate action required.</td>
			</tr>
			<tr>
				<td class="m">Medium</td>
				<td>12 to 5</td>
				<td>Review task and consider additional risk reduction measures.</td>
			</tr>
			<tr>
				<td class="l">Low</td>
				<td>4 to 1</td>
				<td>Acceptable but consider further risk reduction.</td>
			</tr>
		</table>
	</div>
	<div class="span5">
		<h3>Risk Controls</h3>
		<ul>
			<li><strong>Elimination:</strong> Completely remove the hazard.</li>
			<li><strong>Substitution:</strong> Replace with a safer alternative.</li>
			<li><strong>Engineering:</strong> Modify workplace design for safety.</li>
			<li>
				<strong>Administrative:</strong> Implement procedures and training.
			</li>
			<li>
				<strong>PPE (Personal Protective Equipment):</strong> Provide protective
				gear.
			</li>
		</ul>
	</div>
</div>
