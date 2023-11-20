const savedRouter = require("express").Router();
// require("dotenv").config();

var ObjectId = require('mongodb').ObjectId;
const MongoClient = require('mongodb').MongoClient;
const url = "mongodb+srv://TiffPet:COP4331@cluster0.lswztxa.mongodb.net/";
const client = new MongoClient(url);
client.connect();

///////////////////
// API Endpoints //
///////////////////

// Get
// Incoming: id
// Outgoing: name, userId, error
savedRouter.post("/get", async (req, res) => {
    let error = 200;

    const {id} = req.body;
    console.log("Received ID: " + id);

    // some annoying variable jargon
    var UId = new ObjectId(id);

    console.log("Begin GET for Saved Quiz with ID" + UId);

    try
    {
        const db = client.db("LargeProject");
        const result = await db.collection('Saved').find({UserId:UId}).toArray();

        if (result.length > 0)
        {
            console.log("successful");
            const quizList = result.map((item) => {
                return {
                  QuizId: item.QuizId,
                  QuizName: item.QuizName,
                };
              });

              res.status(200).json(quizList);
        }
        else
        {
            var ret = {error:404};
        }
    }
    catch(e)
    {
        error = e.toString();
        var ret = {error:e.message};
    }

    res.status(200).json(ret);
});

// Add
// Incoming: userId, quizId
// Outgoing: id, error
savedRouter.post("/add", async (req, res) => {
	let retCode = 200;
  let message = "";

	const {userId, quizId} = req.body;

	const newQuiz = {UserId: userId, QuizId: quizId};

	console.log("Saving Quiz with userId " + userId + " and quizId " + quizId);

	try
	{
		var result;
		const db = client.db("LargeProject");

		if(userId == "" || quizId == "")
			message = "You have a blank field somewhere. No saved quiz for you!";
		else
			result = await db.collection('Saved').insertOne(newQuiz);

		var ret = {result: result, error: message};
	}
	catch(e)
	{
		retCode = 404;
		var ret = {error: e.message};
	}

	res.status(retCode).json(ret);
});

// Get
// Incoming: id
// Outgoing: name, userId, error
savedRouter.delete("/delete", async (req, res) => {
	let retCode = 200;
  let message = "";
  
	const {id} = req.body;
	var _id = new ObjectId(id);
	
	console.log("Begin DELETE for Saved Quiz " + id);
	
	try
	{
		const db = client.db("LargeProject");

		const result = await db.collection('Saved').deleteOne({_id});
	
		if(result.deletedCount == 1)
			message = "Successfully deleted Saved Quiz " + id;
		else
			retCode = 204;

	var ret = {error: message};
	}
	catch(e)
	{
		retCode = 404;
		var ret = {error: e.message};
	}
	
	
	res.status(retCode).json(ret);
});

module.exports = savedRouter;