uniform float height;
uniform float twistAmount;
uniform float twistAngle;
uniform float bendAngle;
uniform float bendAmount;
varying vec3 normal, lightDir[3], eyeVec;

varying vec4 Color;

vec4 DoTwist( vec4 pos, float t )
{
	float st = sin(t/25.);
	float ct = cos(t/25.);
	vec4 new_pos;
	
	new_pos.y = pos.y*ct - pos.x*st;
	new_pos.x = pos.y*st + pos.x*ct;
	
	new_pos.z = pos.z;
	new_pos.w = pos.w;

	return( new_pos );
}

vec4 DoBend( vec4 pos, float dir, float amt)
{
	vec4 new_pos;
	
	float old_pos_r = sqrt(pos.x * pos.x + pos.y * pos.y);
	float old_pos_theta = atan(pos.y, pos.x);
	
	float new_x_dif = cos(dir) * pos.z* pos.z * amt;
	float new_y_dif = sin(dir) * pos.z* pos.z * amt;	
	
	new_pos.x = pos.x + new_x_dif;
	new_pos.y = pos.y + new_y_dif;	
	new_pos.z = pos.z;
	new_pos.w = pos.w;

	return( new_pos );
}


void main(void)
{

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
	
	lightDir[0] = vec3(gl_LightSource[0].position.xyz - vVertex);
	lightDir[1] = vec3(gl_LightSource[1].position.xyz - vVertex);
	lightDir[2] = vec3(gl_LightSource[2].position.xyz - vVertex);
	eyeVec = -vVertex;

	normal = gl_NormalMatrix * bentNormal.xyz;
	
	//gl_TexCoord[0] = gl_MultiTexCoord0;
	

	
	//Transform vertex by modelview and projection matrices
	//gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex ;
	
	//Forward current color and texture coordinates after applying texture matrix
	//gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;

	
}