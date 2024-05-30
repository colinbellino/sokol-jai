#import "Math";

persp_mat4 :: (fov: float, aspect: float, near: float, far: float) -> Matrix4 {
    m := Matrix4_Identity;
    t := tan(fov * (PI / 360));
    m.coef[0][0] = 1.0 / t;
    m.coef[1][1] = aspect / t;
    m.coef[2][3] = -1.0;
    m.coef[2][2] = (near + far) / (near - far);
    m.coef[3][2] = (2.0 * near * far) / (near - far);
    m.coef[3][3] = 0;
    return m;
}
lookat_mat4 :: (eye: Vector3, center: Vector3, up: Vector3) -> Matrix4 {
    m: Matrix4;
    f := normalize(center - eye);
    s := normalize(cross(f, up));
    u := cross(s, f);

    m.coef[0][0] = s.x;
    m.coef[0][1] = u.x;
    m.coef[0][2] = -f.x;

    m.coef[1][0] = s.y;
    m.coef[1][1] = u.y;
    m.coef[1][2] = -f.y;

    m.coef[2][0] = s.z;
    m.coef[2][1] = u.z;
    m.coef[2][2] = -f.z;

    m.coef[3][0] = -dot(s, eye);
    m.coef[3][1] = -dot(u, eye);
    m.coef[3][2] = dot(f, eye);
    m.coef[3][3] = 1.0;

    return m;
}
multiply_mat4 :: (left: Matrix4, right: Matrix4) -> Matrix4 {
    m: Matrix4;
    for col : 0 .. 3 {
        for row : 0 .. 3 {
            m.coef[col][row] = left.coef[0][row] * right.coef[col][0] +
                               left.coef[1][row] * right.coef[col][1] +
                               left.coef[2][row] * right.coef[col][2] +
                               left.coef[3][row] * right.coef[col][3];
        }
    }
    return m;
}
rotate_mat4 :: (angle: float, axis_unorm: Vector3) -> Matrix4 {
    m := Matrix4_Identity;

    axis := normalize(axis_unorm);
    sin_theta := sin(radians(angle));
    cos_theta := cos(radians(angle));
    cos_value := 1.0 - cos_theta;

    m.coef[0][0] = (axis.x * axis.x * cos_value) + cos_theta;
    m.coef[0][1] = (axis.x * axis.y * cos_value) + (axis.z * sin_theta);
    m.coef[0][2] = (axis.x * axis.z * cos_value) - (axis.y * sin_theta);
    m.coef[1][0] = (axis.y * axis.x * cos_value) - (axis.z * sin_theta);
    m.coef[1][1] = (axis.y * axis.y * cos_value) + cos_theta;
    m.coef[1][2] = (axis.y * axis.z * cos_value) + (axis.x * sin_theta);
    m.coef[2][0] = (axis.z * axis.x * cos_value) + (axis.y * sin_theta);
    m.coef[2][1] = (axis.z * axis.y * cos_value) - (axis.x * sin_theta);
    m.coef[2][2] = (axis.z * axis.z * cos_value) + cos_theta;

    return m;
}
translate_mat4 :: (translation: Vector3) -> Matrix4 {
    m := Matrix4_Identity;
    m.coef[3][0] = translation.x;
    m.coef[3][1] = translation.y;
    m.coef[3][2] = translation.z;
    return m;
}
radians :: (degrees: float) -> float { return degrees * TAU / 360.0; }
