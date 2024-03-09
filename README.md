# keras2circom

keras2circom is a python tool that transpiles a tf.keras model into a circom circuit.

## Installation

First, clone the repository:

```bash
git clone https://github.com/socathie/keras2circom.git
```

Then, install the dependencies. You can use pip:

```bash
pip install -r requirements.txt
```

If you use conda, you can also create a new environment with the following command:

```bash
conda env create -f environment.yml
```

You will also need to install circom and snarkjs. You can run the following commands to install them:

```bash
bash setup-circom.sh
```

Last but not least, run

```bash
npm install
```

## Usage

To use the package, you can run the following command:

```bash
python main.py <model_path> [-o <output_dir>] [--raw]
```

For example, to transpile the model in `models/model.h5` into a circom circuit, you can run:

```bash
python main.py models/model.h5
```

If you want to transpile the model into a circom circuit with "raw" output, i.e. no ArgMax at the end, you can run:

```bash
python main.py models/model.h5 --raw
```

The output in the `output` directory will be:
- the circom circuit in the `circuit.circom`
- the model weights in the `circuit.json` 
- the python code to generate a model internal output to be put into the circuit in the `circuit.py`

#### Input 

Make sure that the input file is a JSON file containing the input to the model. Note that the input must be normalized, have the same shape as the input layer of the model, and have whole numbers, scaled by 10^18.

In the `models/model.ipynb` file, we provide an example of how to generate the input content for a model. You can also see the `output/input.json` file for an example of the input content.

```python
    sample_input, sample_output = X_test[1], y_test[1]
    print("Sample input: {}".format(np.round(sample_input*10**18).astype(int).tolist()))
    print("Corresponding label: {}".format(sample_output))
```

#### Output

The output will be placed in the `output/output.json` file. The output will contain the intermediate witnesses for the circuit.


### Generating Circom Circuit Inputs

In addition to the `circuit.json` we need to generate the rest of the witness inputs for the circuit. This can be done by running the following command:

```bash
python circuit.py <model_path> <input_path> <output_path>
```
Example:
```bash
python circuit.py circuit.json input.json -o .

```



### Generating Proof
##### Preparing the input

The only thing that is different from the circom documentation is the input witness.

The input is the combination of the `circuit.json`, `input.json` and `output.json` file. 

You can run the following command to prepare the input:

```bash
node join_input.js
```

Which will look for the `circuit.json`, `input.json` and `output.json` file in the `output` directory and generate the `final.json` file in the `output` directory.


Please follow the three last steps in the instructions in the [circom](https://docs.circom.io/getting-started/compiling-circuits/) documentation to generate the proof.

in the "Proving circuits" step in point "Powers of Tau"  recommend

```bash
snarkjs powersoftau new bn128 23 pot12_0000.ptau -v
```

## Testing

To test the package, you can run the following command:

```bash
npm test
```
