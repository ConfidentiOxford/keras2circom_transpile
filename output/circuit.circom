pragma circom 2.0.0;

include "../node_modules/circomlib-ml/circuits/Dense.circom";
include "../node_modules/circomlib-ml/circuits/Flatten2D.circom";
include "../node_modules/circomlib-ml/circuits/ReLU.circom";
include "../node_modules/circomlib-ml/circuits/MaxPooling2D.circom";
include "../node_modules/circomlib-ml/circuits/ArgMax.circom";

template Model() {
signal input in[28][28][3];
signal input max_pooling2d_6_out[14][14][3];
signal input flatten_4_out[588];
signal input dense_6_weights[588][64];
signal input dense_6_bias[64];
signal input dense_6_out[64];
signal input dense_6_remainder[64];
signal input dense_6_re_lu_out[64];
signal input dense_7_weights[64][2];
signal input dense_7_bias[2];
signal input dense_7_out[2];
signal input dense_7_remainder[2];
signal input dense_7_softmax_out[1];
signal output out[1];

component max_pooling2d_6 = MaxPooling2D(28, 28, 3, 2, 2);
component flatten_4 = Flatten2D(14, 14, 3);
component dense_6 = Dense(588, 64, 10**18);
component dense_6_re_lu[64];
for (var i0 = 0; i0 < 64; i0++) {
    dense_6_re_lu[i0] = ReLU();
}
component dense_7 = Dense(64, 2, 10**18);
component dense_7_softmax = ArgMax(2);

for (var i0 = 0; i0 < 28; i0++) {
    for (var i1 = 0; i1 < 28; i1++) {
        for (var i2 = 0; i2 < 3; i2++) {
            max_pooling2d_6.in[i0][i1][i2] <== in[i0][i1][i2];
}}}
for (var i0 = 0; i0 < 14; i0++) {
    for (var i1 = 0; i1 < 14; i1++) {
        for (var i2 = 0; i2 < 3; i2++) {
            max_pooling2d_6.out[i0][i1][i2] <== max_pooling2d_6_out[i0][i1][i2];
}}}
for (var i0 = 0; i0 < 14; i0++) {
    for (var i1 = 0; i1 < 14; i1++) {
        for (var i2 = 0; i2 < 3; i2++) {
            flatten_4.in[i0][i1][i2] <== max_pooling2d_6.out[i0][i1][i2];
}}}
for (var i0 = 0; i0 < 588; i0++) {
    flatten_4.out[i0] <== flatten_4_out[i0];
}
for (var i0 = 0; i0 < 588; i0++) {
    dense_6.in[i0] <== flatten_4.out[i0];
}
for (var i0 = 0; i0 < 588; i0++) {
    for (var i1 = 0; i1 < 64; i1++) {
        dense_6.weights[i0][i1] <== dense_6_weights[i0][i1];
}}
for (var i0 = 0; i0 < 64; i0++) {
    dense_6.bias[i0] <== dense_6_bias[i0];
}
for (var i0 = 0; i0 < 64; i0++) {
    dense_6.out[i0] <== dense_6_out[i0];
}
for (var i0 = 0; i0 < 64; i0++) {
    dense_6.remainder[i0] <== dense_6_remainder[i0];
}
for (var i0 = 0; i0 < 64; i0++) {
    dense_6_re_lu[i0].in <== dense_6.out[i0];
}
for (var i0 = 0; i0 < 64; i0++) {
    dense_6_re_lu[i0].out <== dense_6_re_lu_out[i0];
}
for (var i0 = 0; i0 < 64; i0++) {
    dense_7.in[i0] <== dense_6_re_lu[i0].out;
}
for (var i0 = 0; i0 < 64; i0++) {
    for (var i1 = 0; i1 < 2; i1++) {
        dense_7.weights[i0][i1] <== dense_7_weights[i0][i1];
}}
for (var i0 = 0; i0 < 2; i0++) {
    dense_7.bias[i0] <== dense_7_bias[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_7.out[i0] <== dense_7_out[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_7.remainder[i0] <== dense_7_remainder[i0];
}
for (var i0 = 0; i0 < 2; i0++) {
    dense_7_softmax.in[i0] <== dense_7.out[i0];
}
dense_7_softmax.out <== dense_7_softmax_out[0];
out[0] <== dense_7_softmax.out;

}

component main = Model();
