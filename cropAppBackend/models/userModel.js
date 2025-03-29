const mongoose=require ('mongoose');
const {ObjectId}=mongoose.Schema;
const bcrypt=require("bcryptjs");
const jwt=require("jsonwebtoken");
const { type } = require('os');

const userSchema=new mongoose.Schema({
    email:{
        type:String,
        trim:true,
        required:[true,'e-mail is required'],
        unique:true,
        match:[
            /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
            'Please add a valid email'
        ]
    },
    password:{
        type:String,
        trim:true,
        required:[true,'password is required'],
        minlength:[6,'Password must have atleast (6) characters']
    },
    full_name:{
        type:String
    },
    DOB:{
        type:Date
    },
    city:{
        type:String
    },
    state:{
        type:String
    },
    pincode:{
        type:String
    },
    first:{
        type:Boolean
    }
},
{timestamps:true}
)

//Encryption of password before saving:
userSchema.pre('save',async function(next){
    if(!this.isModified('password')){
        next();
    }
    this.password=await bcrypt.hash(this.password,10)
})

//Compare user password:
userSchema.methods.comparePassword=async function(enteredPassword){
    return await bcrypt.compare(enteredPassword,this.password)
};

//Return jwt token:
userSchema.methods.getJwtToken=function(){
    return jwt.sign({id:this.id},process.env.JWT_SECRET,{
        expiresIn:3600
    });
}

module.exports=mongoose.model("User",userSchema);

