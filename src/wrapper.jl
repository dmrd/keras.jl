using PyCall

@pyimport keras.activations as activations
@pyimport keras.callbacks as callbacks
@pyimport keras.objectives as objectives
@pyimport keras.preprocessing as preprocessing
@pyimport keras.utils as utils
@pyimport keras.backend as backend
@pyimport keras.constraints as constraints
@pyimport keras.initializations as initializations
@pyimport keras.models as models
@pyimport keras.optimizers as optimizers
@pyimport keras.regularizers as regularizers
@pyimport keras.wrappers as wrappers
@pyimport keras.layers as layers


# Potential mode for how to do this in the future.
# Perhaps the structure can be recovered automatically so we don't have to hand each module
module datasets
using PyCall
for dataset in [:cifar, :cifar10, :cifar100, :imdb, :mnist, :reuters]
    @eval @pyimport keras.datasets.$dataset as $dataset
end
end
