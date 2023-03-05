import numpy as np


def dbinv(x):
    return 10 ** (x / 10)


def db(X, U):
    R = 1
    X = np.abs(X) ** 2 / R if not U.startswith('power') else X
    return (10 * np.log10(X) + 300) - 300


def get_total_rss(csi_st):
    rssi_vals = [dbinv(csi_st[key]) for key in ['rssi_a', 'rssi_b', 'rssi_c'] if csi_st[key] != 0]
    rssi_mag = np.sum(rssi_vals)
    return db(rssi_mag, 'power') - 44 - csi_st['agc']


def get_scale_factor(csi_st):
    csi_sq = np.multiply(csi_st['csi'], np.conj(csi_st['csi'])).real
    csi_pwr = np.sum(csi_sq, axis=0)
    csi_pwr = csi_pwr.reshape(1, csi_pwr.shape[0], -1)
    rssi_pwr = dbinv(get_total_rss(csi_st))

    scale_factor = rssi_pwr / (csi_pwr / 30)
    return scale_factor


def get_noise_power(csi_st, noise_db=-92):
    thermal_noise_pwr = dbinv(noise_db)
    quant_error_pwr = get_scale_factor(csi_st) * (csi_st['Nrx'] * csi_st['Ntx'])
    total_noise_pwr = thermal_noise_pwr + quant_error_pwr
    return total_noise_pwr


def get_scale_csi(csi_st):
    scale_factor = get_scale_factor(csi_st)
    total_noise_pwr = get_noise_power(csi_st)
    ret = csi_st['csi'] * np.sqrt(scale_factor / total_noise_pwr)

    if csi_st['Ntx'] == 2:
        ret = ret * np.sqrt(2)
    elif csi_st['Ntx'] == 3:
        ret = ret * np.sqrt(dbinv(4.5))

    return ret
