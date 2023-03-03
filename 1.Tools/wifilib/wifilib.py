import numpy as np
import sys
import math

def read_bf_file(filename, decoder="python"):
    with open(filename, "rb") as f:
        bfee_list = []
        field_len = int.from_bytes(f.read(2), byteorder='big', signed=False)
        while field_len != 0:
            bfee_list.append(f.read(field_len))
            field_len = int.from_bytes(f.read(2), byteorder='big', signed=False)

    dicts = []

    count = 0
    triangle = [0, 1, 3]

    for array in bfee_list:
        code = array[0]

        if code != 187:
            continue
        else:
            count += 1
            timestamp_low = int.from_bytes(array[1:5], byteorder='little', signed=False)
            bfee_count = int.from_bytes(array[5:7], byteorder='little', signed=False)
            Nrx = array[9]
            Ntx = array[10]
            rssi_a = array[11]
            rssi_b = array[12]
            rssi_c = array[13]
            noise = array[14] - 256
            agc = array[15]
            antenna_sel = array[16]
            b_len = int.from_bytes(array[17:19], byteorder='little', signed=False)
            fake_rate_n_flags = int.from_bytes(array[19:21], byteorder='little', signed=False)
            payload = array[21:]

            calc_len = (30 * (Nrx * Ntx * 8 * 2 + 3) + 6) // 8
            perm = [1,2,3]
            perm[0] = (antenna_sel) & 0x3
            perm[1] = (antenna_sel >> 2) & 0x3
            perm[2] = (antenna_sel >> 4) & 0x3

            if b_len != calc_len:
                print("MIMOToolbox:read_bfee_new:size", "Wrong beamforming matrix size.")

            if decoder == "python":
                csi = parse_csi(payload, Ntx, Nrx)
            else:
                print("Decoder name error! Wrong encoder name:", decoder)
                return

            if sum(perm) != triangle[Nrx-1]:
                print('WARN ONCE: Found CSI (', filename, ') with Nrx=', Nrx, ' and invalid perm=[', perm, ']\n')
            else:
                csi[:, perm, :] = csi[:, [0, 1, 2], :]

            bfee_dict = {
                'timestamp_low': timestamp_low,
                'bfee_count': bfee_count,
                'Nrx': Nrx,
                'Ntx': Ntx,
                'rssi_a': rssi_a,
                'rssi_b': rssi_b,
                'rssi_c': rssi_c,
                'noise': noise,
                'agc': agc,
                'antenna_sel': antenna_sel,
                'perm': perm,
                'len': b_len,
                'fake_rate_n_flags': fake_rate_n_flags,
                'calc_len': calc_len,
                'csi': csi
            }
            dicts.append(bfee_dict)

    return dicts


def parse_csi(payload, Ntx, Nrx):
    csi = np.zeros(shape=(Ntx, Nrx, 30), dtype=np.dtype(np.complex128))
    index = 0

    for i in range(30):
        index += 3
        remainder = index % 8
        for j in range(Nrx):
            for k in range(Ntx):
                start = index // 8
                real_bin = bytes([(payload[start] >> remainder) | (payload[start + 1] << (8 - remainder)) & 0b11111111])
                real = int.from_bytes(real_bin, byteorder='little', signed=True)
                imag_bin = bytes([(payload[start + 1] >> remainder) | (payload[start + 2] << (8 - remainder)) & 0b11111111])
                imag = int.from_bytes(imag_bin, byteorder='little', signed=True)
                tmp = np.complex128(complex(float(real), float(imag)))
                csi[k, j, i] = tmp
                index += 16
    return csi


if __name__ == '__main__':

    # read csi from file
    filename = sys.argv[1]

    # decode the csi file
    dicts = read_bf_file(filename)
    
    # print the csi
    print(dicts)

