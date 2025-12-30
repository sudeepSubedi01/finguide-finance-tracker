from flask import Blueprint, jsonify, request
from models import db, Category

categories_bp = Blueprint("categories", __name__)

@categories_bp.route("/", methods=['GET'])
def get_categories():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error':'user_id missing'}),400
    categories = Category.query.filter_by(user_id=user_id).all()

    result = []
    for c in categories:
        result.append({'category_id':c.id, 'name':c.name})
    
    return jsonify(result)

@categories_bp.route("/", methods=['POST'])
def create_category():
    data = request.get_json()
    user_id = data.get('user_id')
    name = data.get('name')

    if not name:
        return jsonify({"error": "Name required"}), 400
    
    new_category = Category(user_id=user_id, name=name)

    db.session.add(new_category)
    db.session.commit()

    return jsonify({
        "message": "New category created",
        "user_id": new_category.user_id,
        "name": new_category.name
    })