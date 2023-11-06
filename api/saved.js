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
                  _id: item._id,
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
	let error = 200;

	const {userId, quizId} = req.body;

	const newQuiz = {UserId:userId, QuizId:quizId};

	console.log("Saving Quiz with userId " + userId + " and quizId " + quizId);

	try
	{
		if(userId == "" || quizId == "")
		{
			error = "You have a blank field somewhere. No saved quiz for you!";
			var ret = {error: error};
		}
		else
		{
			const db = client.db("LargeProject");
			const result = await db.collection('Saved').insertOne(newQuiz);
		
			var ret = {id:result.insertedId, userId:userId, quizId:quizId, error: error};
		}
	}
	catch(e)
	{
		error = e.toString();
		var ret = {error:e.message};
	}

	res.status(200).json(ret);
});

module.exports = savedRouter;