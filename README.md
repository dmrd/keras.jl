# keras

[![Build Status](https://travis-ci.org/dmrd/Keras.jl.svg?branch=master)](https://travis-ci.org/dmrd/Keras.jl)

A minimal wrapper around the [Keras](https://github.com/fchollet/keras) deep learning library using [PyCall](https://github.com/stevengj/PyCall.jl) with helper utilities for using it from Julia.

Longer term, I'd like this package to follow the model in [Tensorflow.jl](https://github.com/benmoran/TensorFlow.jl) and define Julia types for each method.

In the meantime, only a few top level modules are explicitly imported.  To get something that is not imported, either:
- Access it using the `[:name]` syntax: `Keras.layers.core[:Dense]`
- Pywrap the part that you want: `c = pywrap(Keras.layers.core); c.Dense`
- Pyimport locally (will not be under Keras module, but will have completion): `@pyimport keras.layers.core as core; core.Dense`.  This is equivalent to `pywrap`

PyCall handles importing docstring from Python, so `?Keras.layers.core[:Dense]` will return documentation for Dense.

# Setting up with Keras
If Keras is not already installed in the PyCall python environment, consider setting it up with a local miniconda distribution:

```
using Conda
ENV["PYTHON"] = ""
push!(Conda.CHANNELS, "https://conda.anaconda.org/jaikumarm")

Conda.add("keras")
Conda.add("h5py")
Pkg.build("PyCall")
```

# Passing data into Keras
Keras expects row major arrays, e.g.: (i, j, k, N examples) on Julia side should be converted to (N Examples, k, j, i) on the Python side.

Convert Julia arrays to PyArray objects with the proper dimension ordering using utils in `src/utils.jl`, specifically `to_python_array`.

# Creating a simple mode

See the `examples` directory for examples (TODO )= ).  For the most part, the Keras docs work equally well, as the API is identical.

# Improvements

- Is there a way to recursively convert the PyObjects to Julia modules instead of having to explicitly (a) create a module for each, or (b) explicitly import as some other name