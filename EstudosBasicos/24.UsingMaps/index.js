var officers = [
    { id: 20, name: 'Captain Piett' , arrayObject : [{"number" : 1},{"number" : 2},{"number" : 3}]},
    { id: 21, name: 'Captain Ted' , arrayObject : [{"number" : 4},{"number" : 5},{"number" : 6}]}
  ];

  officers.map(function (officer) {
      console.log(officer.name);
         officer.arrayObject.map(function(m){
            console.log(m.number);
        });
      console.log("-------");
  });