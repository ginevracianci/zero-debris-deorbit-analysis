import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Read MATLAB results
df = pd.read_csv('C:/Users/GINEVRA/Desktop/zero-debris-deorbit-analysis/data/deorbit_analysis.csv')

# Create comprehensive visualization
fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Plot 1: Delta-V budget
axes[0, 0].plot(df['Altitude_km'], df['DeltaV_ms'], 'o-', linewidth=2, markersize=8)
axes[0, 0].set_xlabel('Altitude (km)')
axes[0, 0].set_ylabel('Delta-V (m/s)')
axes[0, 0].set_title('Active Deorbit Delta-V Requirements')
axes[0, 0].grid(True, alpha=0.3)

# Plot 2: Natural decay time
axes[0, 1].bar(df['Altitude_km'], df['DecayTime_years'], color='steelblue')
axes[0, 1].axhline(y=25, color='r', linestyle='--', linewidth=2, label='ESA 25-year limit')
axes[0, 1].set_xlabel('Altitude (km)')
axes[0, 1].set_ylabel('Decay Time (years)')
axes[0, 1].set_title('Natural Decay Timeline vs ESA Compliance')
axes[0, 1].legend()
axes[0, 1].set_yscale('log')
axes[0, 1].grid(True, alpha=0.3)

# Plot 3: Compliance status
compliance_colors = ['green' if x else 'red' for x in df['ESA_Compliant']]
axes[1, 0].bar(df['Altitude_km'], [1]*len(df), color=compliance_colors)
axes[1, 0].set_xlabel('Altitude (km)')
axes[1, 0].set_ylabel('Compliance Status')
axes[1, 0].set_title('ESA Zero-Debris 25-Year Compliance')
axes[1, 0].set_yticks([])

# Plot 4: Summary table
axes[1, 1].axis('off')
table_data = df[['Altitude_km', 'DeltaV_ms', 'DecayTime_years']].round(1)
table = axes[1, 1].table(cellText=table_data.values, 
                         colLabels=['Alt (km)', 'ΔV (m/s)', 'Decay (yr)'],
                         cellLoc='center', loc='center')
table.auto_set_font_size(False)
table.set_fontsize(10)
table.scale(1, 2)

plt.tight_layout()
plt.savefig('C:/Users/GINEVRA/Desktop/zero-debris-deorbit-analysis/plots/python_comprehensive_analysis.png', dpi=300, bbox_inches='tight')
print("Python analysis complete!")
plt.show()