import sys
import numpy as np
import matplotlib.pyplot as plt
from wifilib import wifilib as csi
from wifilib import CSIscale as csi_scale

if len(sys.argv) < 2:
    print("Usage: python3 plot_csi.py [csi file]")
    sys.exit()

path = sys.argv[1]
bf = csi.read_bf_file(path)
csi_list = list(map(csi_scale.get_scale_csi,bf))
csi_np = (np.array(csi_list))
csi_amp = np.abs(csi_np)

print("csi shape: ",csi_np.shape)
fig = plt.figure()
plt.plot(csi_amp[:,0,0,3])
plt.show()