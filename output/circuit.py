""" Make an interger-only circuit of the corresponding CIRCOM circuit.

Usage:
    circuit.py <circuit.json> <input.json> [-o <output>]
    circuit.py (-h | --help)

Options:
    -h --help                               Show this screen.
    -o <output> --output=<output>           Output directory [default: output].

"""

from docopt import docopt
import json

try:
    from keras2circom.util import *
except:
    import sys
    import os
    # add parent directory to sys.path
    sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    from keras2circom.util import *

def inference(input, circuit):
    out = input['in']
    output = {}
    
    out = MaxPooling2DInt(28, 28, 3, 2, 2, out)
    output['max_pooling2d_6_out'] = out

    out = Flatten2DInt(14, 14, 3, out)
    output['flatten_4_out'] = out

    out, remainder = DenseInt(588, 64, 10**18, out, circuit['dense_6_weights'], circuit['dense_6_bias'])
    output['dense_6_out'] = out
    output['dense_6_remainder'] = remainder

    out = ReLUInt(64, 1, 1, out)
    output['dense_6_re_lu_out'] = out

    out, remainder = DenseInt(64, 2, 10**18, out, circuit['dense_7_weights'], circuit['dense_7_bias'])
    output['dense_7_out'] = out
    output['dense_7_remainder'] = remainder

    out = ArgMaxInt(out)
    output['dense_7_softmax_out'] = out


    return out, output


def main():
    """ Main entry point of the app """
    args = docopt(__doc__)
    
    # parse input.json
    with open(args['<input.json>']) as f:
        input = json.load(f)
    
    # parse circuit.json
    with open(args['<circuit.json>']) as f:
        circuit = json.load(f)

    out, output = inference(input, circuit)

    # write output.json
    with open(args['--output'] + '/output.json', 'w') as f:
        json.dump(output, f)

if __name__ == "__main__":
    """ This is executed when run from the command line """
    main()
