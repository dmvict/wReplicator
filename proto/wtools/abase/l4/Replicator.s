( function _Replicator_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to replicate a complex data structure. It traverse input data structure deeply producing a copy of it.Collection of cross-platform routines to replicate a complex data structure. It traverses input data structure deeply producing a copy of it.
  @module Tools/base/Replicator
  @extends Tools
*/

/**
 * Collection of cross-platform routines to replicate a complex data structure.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wLooker' );

}

let _global = _global_;
let _ = _global_.wTools
let Parent = _.Looker;
_.replicator = _.replicator || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// relations
// --

var Defaults = _.mapExtend( null, _.look.defaults )
Defaults.Looker = null;
Defaults.root = null;
Defaults.src = null;
Defaults.dst = null;

// --
// routines
// --

function head( routine, args )
{
  let o = Self.optionsFromArguments( args );
  o.Looker = o.Looker || routine.defaults.Looker || Self;
  _.routineOptionsPreservingUndefines( routine, o );
  o.Looker.optionsForm( routine, o );
  let it = o.Looker.optionsToIteration( o );
  return it;
}

//

function optionsFromArguments( args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  {
    if( _.replicator.iterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], dst : args[ 1 ] }
    else
    o = { src : args[ 0 ], dst : args[ 1 ] }
  }

  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );

  return o;
}

//

function optionsForm( routine, o )
{
  Parent.optionsForm.call( this, routine, o );

  _.assert( arguments.length === 2 );
  _.assert( o.onUp === null || _.routineIs( o.onUp ) );
  _.assert( o.onDown === null || _.routineIs( o.onDown ) );
  _.assert( o.it === undefined );
  _.assert( o.replicateOptions === undefined );

  return o;
}

//

function optionsToIteration( o )
{
  let it = Parent.optionsToIteration.call( this, o );
  return it;
}

// //
// 
// function perform()
// {
//   let it = this;
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   it.performBegin();
//   it.iterate();
//   it.performEnd();
//   return it;
// }

//

function performBegin()
{
  let it = this;
  _.assert( it.iterationProper( it ) );
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return it;
}

//

function performEnd()
{
  let it = this;
  it.iterator.result = it.dst;
  return it;
}

//

function dstWriteDownEval()
{
  let it = this;
  it.dstWriteDown = null;

  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( it.dstWriteDown === null );

  if( !it.iterable )
  {
    it.dstWriteDown = function dstWriteDown( eit )
    {
      _.assert( 0, 'Cant write into terminal' );
    }
  }
  else if( it.iterable === _.looker.containerNameToIdMap.countable )
  {
    it.dstWriteDown = function dstWriteDown( eit )
    {
      if( eit.dst !== undefined )
      this.dst.push( eit.dst );
    }
  }
  else if( it.iterable === _.looker.containerNameToIdMap.aux )
  {
    it.dstWriteDown = function dstWriteDown( eit )
    {
      if( eit.dst === undefined )
      delete this.dst[ eit.key ];
      else
      this.dst[ eit.key ] = eit.dst;
    }
  }
  else if( it.iterable === _.looker.containerNameToIdMap.hashMap )
  {
    it.dstWriteDown = function dstWriteDown( eit )
    {
      _.assert( 0, 'not tested' ); /* qqq : test */
      if( eit.dst === undefined )
      this.dst.delete( eit.key );
      else
      this.dst.set( eit.key, eit.dst );
    }
  }
  else if( it.iterable === _.looker.containerNameToIdMap.set )
  {
    it.dstWriteDown = function dstWriteDown( eit )
    {
      _.assert( 0, 'not tested' ); /* qqq : test */
      if( eit.dst === undefined )
      this.dst.delete( eit.dst );
      else
      this.dst.set( eit.dst );
    }
  }

}

//

function dstMake()
{
  let it = this;

  _.assert( it.dst === null );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( it.dstMaking );
  _.assert( arguments.length === 0 );

  if( !it.iterable )
  {
    it.dst = it.src;
  }
  else if( it.iterable === _.looker.containerNameToIdMap.countable )
  {
    it.dst = [];
  }
  else if( it.iterable === _.looker.containerNameToIdMap.aux )
  {
    it.dst = Object.create( null );
  }
  else if( it.iterable === _.looker.containerNameToIdMap.hashMap )
  {
    it.dst = new HashMap;
  }
  else if( it.iterable === _.looker.containerNameToIdMap.set )
  {
    it.dst = new Set;
  }

}

//

function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  let result = Parent.srcChanged.call( it );

  it.dstWriteDownEval();

  return result;
}

//

function visitUpEnd()
{
  let it = this;

  if( it.dstMaking )
  it.dstMake();

  return Parent.visitDownEnd.call( it );
}

//

function visitDownEnd()
{
  let it = this;

  _.assert( it.iterable !== null && it.iterable !== undefined );

  if( it.down && it.dstWritingDown )
  {
    _.assert( _.routineIs( it.down.dstWriteDown ) );
    it.down.dstWriteDown( it );
  }

  return Parent.visitDownEnd.call( it );
}

//

function replicate_head( routine, args )
{
  return Self.head( routine, args );
}

//

/* xxx qqq : implement please replication with buffer sepration
*/

// function cloneDataSeparatingBuffers( o )
// {
//   var result = Object.create( null );
//   var buffers = [];
//   var descriptorsArray = [];
//   var descriptorsMap = Object.create( null );
//   var size = 0;
//   var offset = 0;
//
//   _.routineOptions( cloneDataSeparatingBuffers, o );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   /* onBuffer */
//
//   o.onBuffer = function onBuffer( srcBuffer, it )
//   {
//
//     _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//     _.assert( _.bufferTypedIs( srcBuffer ), 'not tested' );
//
//     var index = buffers.length;
//     var id = _.strJoin([ '--buffer-->', index, '<--buffer--' ]);
//     var bufferSize = srcBuffer ? srcBuffer.length*srcBuffer.BYTES_PER_ELEMENT : 0;
//     size += bufferSize;
//
//     let bufferConstructorName;
//     if( srcBuffer )
//     {
//       let longDescriptor = _.LongTypeToDescriptorsHash.get( srcBuffer.constructor );
//
//       if( longDescriptor )
//       bufferConstructorName = longDescriptor.name;
//       else
//       bufferConstructorName = srcBuffer.constructor.name;
//
//     }
//     else
//     {
//       bufferConstructorName = 'null';
//     }
//
//     var descriptor =
//     {
//       'bufferConstructorName' : bufferConstructorName,
//       'sizeOfScalar' : srcBuffer ? srcBuffer.BYTES_PER_ELEMENT : 0,
//       'offset' : -1,
//       'size' : bufferSize,
//       'index' : index,
//     }
//
//     buffers.push( srcBuffer );
//     descriptorsArray.push( descriptor );
//     descriptorsMap[ id ] = descriptor;
//
//     it.dst = id;
//
//   }
//
//   /* clone data */
//
//   result.data = _._clone( o );
//   result.descriptorsMap = descriptorsMap;
//
//   /* sort by atom size */
//
//   descriptorsArray.sort( function( a, b )
//   {
//     return b[ 'sizeOfScalar' ] - a[ 'sizeOfScalar' ];
//   });
//
//   /* alloc */
//
//   result.buffer = new BufferRaw( size );
//   var dstBuffer = _.bufferBytesGet( result.buffer );
//
//   /* copy buffers */
//
//   for( var b = 0 ; b < descriptorsArray.length ; b++ )
//   {
//
//     var descriptor = descriptorsArray[ b ];
//     var buffer = buffers[ descriptor.index ];
//     var bytes = buffer ? _.bufferBytesGet( buffer ) : new U8x();
//     var bufferSize = descriptor[ 'size' ];
//
//     descriptor[ 'offset' ] = offset;
//
//     _.bufferMove( dstBuffer.subarray( offset, offset+bufferSize ), bytes );
//
//     offset += bufferSize;
//
//   }
//
//   return result;
// }
//
// cloneDataSeparatingBuffers.defaults =
// {
//   copyingBuffers : 1,
// }
//
// cloneDataSeparatingBuffers.defaults.__proto__ = cloneData.defaults;

//

function replicateIt_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.looker.is( it.Looker ) );
  _.assert( it.looker === undefined );
  _.look.body( it ); /* xxx : perform */
  return it;
}

var defaults = replicateIt_body.defaults = Defaults;

//

/**
 * @summary Replicates a complex data structure using iterator.
 * @param {Object} o Options map
 * @param {Object} o.it Iterator object
 * @param {Object} o.root
 * @param {Object} o.src Source data structure
 * @param {Object} o.dst Target data structure
 * @param {Number} o.recursive=Infinity
 *
 * @returns {Object} Returns `dst` structure.
 * @function replicateIt
 * @namespace Tools
 * @module Tools/base/Replicator
 */


let replicateIt = _.routineUnite( replicate_head, replicateIt_body );

//

function replicate_body( it )
{
  let it2 = _.replicateIt.body( it );
  _.assert( it2 === it )
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( it.error )
  throw it.error;

  debugger; /* xxx : result? */
  return it.dst;
}

_.routineExtend( replicate_body, replicateIt.body );

//

/**
 * @summary Replicates a complex data structure.
 * @param {*} src Source data scructure
 * @param {*} dst Target data scructure
 *
 * @returns {} Returns `dst` structure.
 * @function replicate
 * @namespace Tools
 * @module Tools/base/Replicator
 */

let replicate = _.routineUnite( replicate_head, replicate_body );

// --
// relations
// --

var Defaults = _.mapExtend( null, _.look.defaults )
Defaults.Looker = null;
Defaults.root = null;
Defaults.src = null;
Defaults.dst = null;

let Replicator = Object.create( Parent );
Replicator.constructor = function Replicator(){};
Replicator.Looker = Replicator;
Replicator.performMaking = replicateIt;
Replicator.head = head;
Replicator.optionsFromArguments = optionsFromArguments;
Replicator.optionsForm = optionsForm;
Replicator.optionsToIteration = optionsToIteration;
// Replicator.perform = perform;
Replicator.performBegin = performBegin;
Replicator.performEnd = performEnd;
Replicator.dstWriteDownEval = dstWriteDownEval;
Replicator.dstMake = dstMake;
Replicator.srcChanged = srcChanged;
Replicator.visitUpEnd = visitUpEnd;
Replicator.visitDownEnd = visitDownEnd;

let Iterator = Replicator.Iterator = _.mapExtend( null, Replicator.Iterator );
Iterator.result = null;

let Iteration = Replicator.Iteration = _.mapExtend( null, Replicator.Iteration );
Iteration.dst = null;
Iteration.dstMaking = true;
Iteration.dstWriteDown = null;
Iteration.dstWritingDown = true;

//

let ReplicatorExtension =
{

  ... _.looker,

  // is : _.looker.is,
  // iteratorIs : _.looker.iteratorIs,
  // iterationIs : _.looker.iterationIs,
  // define : _.looker.define,

  Replicator,
  replicateIt,
  replicate,

}

let ToolsExtension =
{

  // Replicator,

  replicateIt,
  replicate,

}

let Self = Replicator;
_.mapSupplement( _, ToolsExtension );
_.mapSupplement( _.replicator, ReplicatorExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
