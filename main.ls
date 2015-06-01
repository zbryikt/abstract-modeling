require! <[./model]>


base = {}

base.user = new model do
  base: do
    name: {max: 20, type: model.type.string }

base.name = new model do
  self: {required: true, min: 1, max: 20, type: model.type.string, default: \untitled}

base.tag = new model  self: {max: 20, min: 1, type: model.type.string}
base.tags = new model self: {max: 20, type: model.type.array(base.tag), default: []}
base.semantic = new model self: {max: 20, min: 1, type: model.type.string}

base.colorhex = new model do
  self: {max: 7, min: 4}
  lint: ->
    ret = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/.exec it
    return if !ret => [true,null,\format] else [false]

base.color = new model do
  base: do
    hex: {required: true, type: base.colorhex}
    semantic: {type: model.type.semantic}

base.palette = new model do
  name: \palette
  base: do
    name: {type: base.name}
    tags: {type: base.tags}
    key: {type: model.type.id}
    colors: {required: true, min: 1, max: 20, type: model.type.array({type: base.color}), default: []}
    owner: {required: true, type: base.user}
  expand: -> base.palette.create! <<< {key: it}
  shrink: -> it.key

base.palset = new model do
  name: \palset
  base: do
    name: {type: base.name}
    tags: {type: base.tags}
    key: {type: model.type.id}
    palettes: {required: true, min: 0, type: model.type.keys({type: base.palette}), default: []}
    owner: {required: true, type: base.user}

result = base.palette.lint do
  name: \tkirby, count: 0, colors: [{hex: \#ff00ff}], owner: \tkirby
console.log JSON.stringify(result)
console.log base.palette.create!
palset = base.palset.create!
palset.palettes.push \1476281256834
console.log palset
base.palset.expand palset
console.log palset
base.palset.shrink palset
console.log palset
