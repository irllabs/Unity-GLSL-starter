Shader "GLSL basic shader" { // defines the name of the shader 
    Properties {

    	_MainTex ("Texture Image", 2D) = "white" {} 
        height ("Height", Range(0.,2.)) = 0.25
        twistAngle ("Twist Angle", Range(0.,360.)) = 0.
        twistAmount ("Twist Amount", Range(-1.,1.)) = 0.
        bendAngle ("Bend Angle", Range(0.,360.)) = 0.
        bendAmount ("Bend Amount", Range(-1.,1.)) = 0.
    }
   SubShader { // Unity chooses the subshader that fits the GPU best
      Pass { // some shaders require multiple passes
         GLSLPROGRAM // here begins the part in Unity's GLSL

 
         #ifdef VERTEX // here begins the vertex shader

        uniform sampler2D _MainTex;	
        uniform vec4 _MainTex_ST;   // tiling and offset parameters of property 
        varying vec4 textureCoordinates;

        uniform float height;
		uniform float twistAmount;
		uniform float twistAngle;
		uniform float bendAngle;
		uniform float bendAmount;
		varying vec3 normal, lightDir[3], eyeVec;

		vec4 DoTwist( vec4 pos, float t )
		{
			float st = sin(t/25.);
			float ct = cos(t/25.);
			vec4 new_pos;

			//Old
			//new_pos.y = pos.y*ct - pos.x*st;
			//new_pos.x = pos.y*st + pos.x*ct;
			//new_pos.z = pos.z;
			//new_pos.w = pos.w;

			//New - tranlsated to Unity coordinate system with x-z plane being the new x-y plane
			new_pos.z = pos.z*ct - pos.x*st;
			new_pos.x = pos.z*st + pos.x*ct;
			
			new_pos.y = pos.y;
			new_pos.w = pos.w;

			return( new_pos );
		}

		vec4 DoBend( vec4 pos, float dir, float amt)
		{
			vec4 new_pos;

			//Old
			//float old_pos_r = sqrt(pos.x * pos.x + pos.y * pos.y);
			//float old_pos_theta = atan(pos.y, pos.x);
			//float new_x_dif = cos(dir) * pos.z* pos.z * amt;
			//float new_y_dif = sin(dir) * pos.z* pos.z * amt;	
			
			//new_pos.x = pos.x + new_x_dif;
			//new_pos.y = pos.y + new_y_dif;	
			//new_pos.z = pos.z;
			//new_pos.w = pos.w;


			//New - tranlsated to Unity coordinate system with x-z plane being the new x-y plane
			float old_pos_r = sqrt(pos.x * pos.x + pos.z * pos.z);
			float old_pos_theta = atan(pos.z, pos.x);
			
			float new_x_dif = cos(dir) * pos.y* pos.y * amt;
			float new_z_dif = sin(dir) * pos.y* pos.y * amt;	
			
			new_pos.x = pos.x + new_x_dif;
			new_pos.z = pos.z + new_z_dif;	
			new_pos.y = pos.y;
			new_pos.w = pos.w;
			return( new_pos );
		}


		void main(void)
		{

			//setup
			float angle_deg = twistAngle * twistAmount;
			float angle_rad = angle_deg * 3.14159 / 180.0;
			float ang = (height * 0.5 + gl_Vertex.y)/height * angle_rad;
			float bendAngle_rad = bendAngle * 3.14159 / 180.0;

			//twist it
			vec4 twistedPosition = DoTwist(gl_Vertex, ang);
			vec4 twistedNormal = DoTwist(vec4(gl_Normal, ang), 90.); 
			
			//bend it
			vec4 bentPosition = DoBend(twistedPosition, bendAngle_rad, bendAmount);
			vec4 bentNormal = DoBend(vec4(gl_Normal, ang), bendAngle_rad, bendAmount); 
			
			//gl_Position = gl_ModelViewProjectionMatrix * twistedPosition;
			gl_Position = gl_ModelViewProjectionMatrix * bentPosition;
			
			vec3 vVertex = vec3(gl_ModelViewMatrix * bentPosition);
			
			//lightDir[0] = vec3(gl_LightSource[0].position.xyz - vVertex);
			//lightDir[1] = vec3(gl_LightSource[1].position.xyz - vVertex);
			//lightDir[2] = vec3(gl_LightSource[2].position.xyz - vVertex);
			//eyeVec = -vVertex;

			normal = gl_NormalMatrix * bentNormal.xyz;
			textureCoordinates = gl_MultiTexCoord0;
		}
         #endif // here ends the definition of the vertex shader


         #ifdef FRAGMENT // here begins the fragment shader
         //Declare a 2D texture as a uniform variable

		uniform sampler2D _MainTex;
		uniform vec4 _MainTex_ST;   // tiling and offset parameters of property 
		varying vec4 textureCoordinates;

		void main()
		{


   			// textureCoordinates are multiplied with the tiling parameters and the offset parameters are added

   			gl_FragColor = texture2D(_MainTex,  _MainTex_ST.xy * textureCoordinates.xy + _MainTex_ST.zw);	

   			//gl_FragColor = textureExternal(_MainTex, TextureCoordinate);
   			//gl_FragData[0] = textureExternal(_MainTex, uv);
		}

         #endif // here ends the definition of the fragment shader

         ENDGLSL // here ends the part in GLSL 
      }
   }
}
