const http = require('http');
const express = require('express');
const app = express();
app.get("/", (request, response) => {
  console.log(Date.now() + " Ping Received");
  response.sendStatus(200);
});
app.listen(process.env.PORT);
setInterval(() => {
  http.get(`http://${process.env.PROJECT_DOMAIN}.glitch.me/`);
}, 280000);
var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));
const Discord = require("discord.js");
const talkedRecently = new Set();
const newUsers = new Discord.Collection();
const client = new Discord.Client();
const SQLite = require("better-sqlite3");
const sql = new SQLite('./scores.sqlite');
client.on("ready", () => {

	client.user.setStatus('Online')
	client.user.setActivity('type k!help')
	console.log("I am ready!");
  const table = sql.prepare("SELECT count(*) FROM sqlite_master WHERE type='table' AND name = 'scores';").get();
  if (!table['count(*)']) {

    sql.prepare("CREATE TABLE scores (id TEXT PRIMARY KEY, user TEXT, status TEXT);").run();

    sql.prepare("CREATE UNIQUE INDEX idx_scores_id ON scores (id);").run();
    sql.pragma("synchronous = 1");
    sql.pragma("journal_mode = wal");
  }
  client.getScore = sql.prepare("SELECT * FROM scores WHERE id = ?");
  client.setScore = sql.prepare("INSERT OR REPLACE INTO scores (id, user, status) VALUES (@id, @user, @status);");
});

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}
client.on("guildMemberAdd", (member) => {
  const guild = member.guild;
  newUsers.set(member.id, member.user);

  if (newUsers.size > 0) {

    const userlist = newUsers.map(u => u.toString()).join(" ");
    member.guild.channels.get('466288607200673792').send("Hey! " + userlist + " Welcome to My Server :smile:");
    newUsers.clear();
  }
});
client.on("message", message => {
	const argz = message.content.toLowerCase().slice(0).trim().split(/ +/g);
	if(argz[0] === 'hi' || argz[0] === 'hoi' || argz[0] === 'hello' || argz[0] === 'hey') {
		message.reply("Hello! :smile:")
	}

	if(message.content.startsWith("k!")) {


	   const args = message.content.slice(2).trim().split(/ +/g);
	   const command = args.shift().toLowerCase();
		let score;
		if (command === 'ping') {

			return message.channel.send({embed: {
                color: 3447003,
				description: ':ping_pong:  |   Your ping is `' + `${Date.now() - message.createdTimestamp}` + ' ms`'
				}});



	  }
	     const modRolez = message.guild.roles.find("name", "Leader");
	     if (talkedRecently.has(message.author.id) && !message.member.roles.has(modRolez.id)) {
	     	message.react('🕐')
            message.channel.send({embed: {
                color: 3447003,
				description: "Wait **10 seconds** before using a command again. - " + message.author
				}})
             .then(msg => {
				    msg.delete(10000)
				  })

    } else {

           // the user can type the command ... your command code goes here :)

        // Adds the user to the set so that they can't talk for a minute
        talkedRecently.add(message.author.id);
        setTimeout(() => {

          talkedRecently.delete(message.author.id);
        }, 10000);

		if(command ==='flip'){

			skol = getRandomInt(1,3)
			const coin = message.guild.emojis.find("name","coin");

			const embed = new Discord.RichEmbed()
			   .setAuthor("Coinflip Results")
			   .setTimestamp()
			   .setFooter(`Requested by ${message.author.username}`)
			   .setColor(0x00AE86)


			if(skol === 1){
				embed.setDescription(`${coin} | You got **Tails!**`)
				return message.channel.send({embed});

			}
			if(skol === 2){
				embed.setDescription(`${coin} | You got **Heads!**`)
				return message.channel.send({embed});


			}



		}
		if(command ==='rolldice'){
			skel = getRandomInt(1,7)
			const dice = message.guild.emojis.find("name","dice");
			const embed = new Discord.RichEmbed()
			   .setAuthor("Rolling")
			   .setTimestamp()
			   .setFooter(`Requested by ${message.author.username}`)
			   .setColor(0x00AE86)
			   .setDescription(`${dice} | The result was **${skel}**`)
			return message.channel.send({embed});

		}
		if(command === 'say'){
			let text = args.slice(0).join(" ");
			message.delete();
			message.channel.send(text);

		}

	  if(command ==='help'){
		 const embed = new Discord.RichEmbed()

		     .setAuthor("Hi This Bot was made by me,TheArmKing", "https://image.ibb.co/eS4uUy/image.png")

				  .setColor(0x00AE86)
				  .setDescription("The line in `a box` is the command name and the line below is the explanation :smile:")
				  .setFooter(`Help Requested by ${message.author.username}`, `${message.author.avatarURL}`)

				  .setThumbnail("https://image.ibb.co/eS4uUy/image.png")

				  .setTimestamp()
				   .addField("`k!show`", "**Shows the current mods i am working on**")
           .addBlankField(true)
				  .addField("`k!ping`",
				    "Shows your current ping when connecting to the bot in milliseconds")
				  .addBlankField(true)
				  .addField("`k!flip`", "Flips a coin for you")
           .addBlankField(true)
				  .addField("`k!rolldice`", "Rolls a standard 6 number dice for you")
           .addBlankField(true)
				  .addField("`k!say`", "The bot says what you tell it and deletes your original message \n Example Usage: k!say TheArmKing is sexy")
           .addBlankField(true)
				  .addField("`k!asl` *(Age,Sex,location)*", "The Bot asks you out on a date based on your asl \n Example Usage: k!asl 14,Male,USA (always seperate by comma)")
           .addBlankField(true);


          message.channel.send({embed});


	  }
	  if(command === 'set') {
	  	   const modRole = message.guild.roles.find("name", "Leader");
         const sc = client.getScore.get(args[0]);

	  	   if(message.member.roles.has(modRole.id)){


	         let reason = args.slice(1).join(" ");
           if(args[1]==='TBU') {
              score = {id:(args[0]),user: sc.user,status: '*Mod Ready*, Will be Uploaded Soon'}
           }
           else if(args[1]==='Done' && args[2] === undefined) {
              score = {id:(args[0]),user: sc.user,status: '*DONE*, Mod is uploaded!'}
           }
           else{
		  	      score = {id:(args[0]),user: reason,status: 'Working on it :)'}
           }
				client.setScore.run(score)

				message.channel.send({embed: {
                color: 9760690,
				description: ':white_check_mark: | Successfuly set To-Do List Number ' + args[0].toString()+' to ' +reason
				}});
		}
		    if(!message.member.roles.has(modRole.id)){

	            message.channel.send({embed: {
                color: 14485030,
				description: ":x: | You don't have the permisson to do that"
				}});

		}

	  }
	  if(command === 'prune') {
	  	   const modRole = message.guild.roles.find("name", "Leader");
         const modRole2 = message.guild.roles.find("name", "Moderators");

	  	   if(message.member.roles.has(modRole.id) || message.member.roles.has(modRole2.id)){
	  	   	    message.delete()
	  	   	    message.channel.bulkDelete(args[0])
	  	   	    let num = args[0]
	  	   	    message.channel.send({embed: {
                color: 9760690,
				description: ":wastebasket: | " + `Successfuly deleted **${num}** messages from this channel!`
				}})
				  .then(msg => {
				    msg.delete(5000)
				  })


		}
		    if(!message.member.roles.has(modRole.id)){

	            message.channel.send({embed: {
                color: 14485030,
				description: ":x: | You don't have the permisson to do that"
				}});

		}

	  }
	  if(command === 'show'){
	  	 var stmt = sql.prepare('SELECT * FROM scores ORDER BY id + 0 ASC');
		  	const embed = new Discord.RichEmbed()

			    .setAuthor("Hi! This list shows the status of games i am working on", "https://image.ibb.co/eS4uUy/image.png")
			    .setColor(0x00AE86)
			    .setTimestamp()
          .setTitle("Youtube Channel")
          .addBlankField(true)
          .setURL('https://youtube.com/c/TheArmKing')
			    .setFooter(`List Requested by ${message.author.username}`, `${message.author.avatarURL}`);
		    for (var row of stmt.iterate()) {
		    	if(row.user != 'TBD'){
		      		embed.addField(row.id +') ' + row.user.toString(),'**Status**: '+row.status.toString())
              embed.addBlankField(true);


		  }
		  }
            return message.channel.send({embed});

		}







	  if (command === "asl") {

	  	  const argsz = message.content.slice(5).trim().split(',');

		  let age = argsz[0]; // Remember arrays are 0-based!.
		  let sex = argsz[1];
		  let location = argsz[2];

		  if(argsz.length === 3){
		  	message.react('💋')
		  	message.reply(`I see you're a ${age} year old ${sex} from ${location}. Wanna date?`);
		  }
		  else{
		  	message.reply('Uh you need to declare 3 things -> age,sex,location(asl) seperated by commas.\n\nExample:`14,Male,USA`')
		  }





		}
   }
}


});

client.login(process.env.TOKEN);
