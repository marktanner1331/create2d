import './LinePropertiesMixin.dart';

class MultiObjectEngine {
  //so line.dart includes the line properties mixin
  //which depends on context properties mixin
  //but this seems overkill as the line itself doesnt need context properties
  //as we will never be going directly from the view to the model
  //we need a controller, such as the MultiObjectEngine (which needs renaming)
  //so it makes no sense for it to have that
  //but i still like the idea of the model mixins on their own
  //its just when we mix it with the context properties, which is actually more like 
  //a controller that we have the problem
  //also, none of this really supports multiple objects too well
  //at best we can find a nice hack for it
  //its like we need line properties mixin to be more pure
  //so it can be used for tools, shapes, and the multi object controller
  //but also with the ability for it to talk to its controller if necessary
  //so that we can go from the view to the controller without having to wire it
  //although do we really want that?
  //mvc is god in this case
  //so we can have a linecontroller
  //that the view talks to
  //and this line controller can update multiple objects that contain the line mixin
  //and also handle refreshing the graphics and properties windows, etc
  //but we already have that with the line view controller
  //so maybe we need to be modifying that to handle multiple models
  //ok so how would that work?
  //in the case of a tool, we just need the controller to update its properties
  //in the case of a multi object engine
  //  we need to not have one?
  //  i.e. the select tool just gives all the models to the controller
  //  which can then spin through and update as necessary?
  //  maybe a cheeky callback as well to say 'i have changed something, refresh your stuff'
  //  so the controller fires events
  //  rather than the model
  //how will this work with rigidity?
  //  we don't exactly want to have to change the select tool each time we add in a new mixin
  //  or if we do have to then we want minimal changes
  //  such as abstracting it to this handy class
  //  might be best anyway
  //so we will have to hardcode a list of types in this class
  //  and spin through them to see which objects support each
  //  and initialize the controller with this list
  //  and listen out for the change events
  //  then when it occurs
  //  the model has already been updated
  //  and these controller cleans up the rest
  //  that works! i think
  //so when generating the list of controllers from the model, are we still doing that?
  //  i like the idea as its not rigid at all
  //  we just mix in the mixin
  //  and it does the rest
  //  but it does mean bad things when we want one controller to handle multiple models
  //  so maybe its not best
  //  so instead, we still use the multi object engine?
  //  but pass it the tool, instead of the list of shapes?
  //  that can still spin through and generate the right controllers
  //  so maybe this class just proxies the on changed callback
  //  back to the tool
  //  so it can do different things based on the context
  //  i.e. it can refresh the graphics if its selected shapes that have changed
  //  or it can do fuck all of its just the tool properties that have changed
  //so finally, this class, it can handle multiple mixins on multiple objectvs
  //  and is itself a controller
  //  so what do we call it
  //  PropertyEngine.dart sounds good to me
  //  lets not have a hardcoded list of mixins to check each object for
  //  instead
  //  we onExit() all current view controllers
  //  then we spin through each selected shape
  //  which registers itself with each view controller it supports
  //  and returns a hashset of view controllers
  //  then we spin through that list
  //  and call onEnter()
  //  and it already has all its models sorted
}