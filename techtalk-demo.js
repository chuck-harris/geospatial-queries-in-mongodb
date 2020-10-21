
db.restaurants.find();


db.restaurants.find( { location: {
    $geoIntersects: {
        $geometry: { type: "Polygon",
        coordinates: [ [ [ -97, 33 ], [ -97, 32 ], [ -96, 32 ], [ -96, 33 ], [ -97, 33 ] ] ]
    }
} } } );

db.restaurants.find( { location: {
    $geoWithin: {
        $geometry: { type: "Polygon",
        coordinates: [ [ [ -97, 33 ], [ -97, 32 ], [ -96, 32 ], [ -96, 33 ], [ -97, 33 ] ] ]
    }
} } } );

db.restaurants.aggregate( [
  { $geoNear : {
    near: {
      type: "Point",
      coordinates: [ -96.792850, 32.807020 ]
    },
    maxDistance: 32000,
    spherical: true,
    distanceField: "distance_in_miles",
    distanceMultiplier: 0.000621371
  }
  }
] );

db.restaurants.find( { location:
  { $near : {
    $geometry: {
      type: "Point",
      coordinates: [ -96.792850, 32.807020 ]
    },
    $maxDistance: 32000
  }
  }
}
);

db.restaurants.find( { location:
  { $nearSphere : {
    $geometry: {
      type: "Point",
      coordinates: [ -96.792850, 32.807020 ]
    },
    $maxDistance: 32000
  }
  }
}
);



