-- Seeding attractive badges for ShineShelf

-- First, clear existing badges if any
DELETE FROM user_badges;
DELETE FROM badges;

-- Insert new premium badges
INSERT INTO badges (name, description, icon_url, trigger_logic) VALUES
('First Chapter', 'Your journey begins! You''ve successfully finished your first book.', 'badge_first_chapter', 'read_1'),
('High Five', 'Five books down! You''re becoming a regular around here.', 'badge_high_five', 'read_5'),
('Perfect Ten', 'Ten literary adventures completed. Your library card is getting a workout!', 'badge_perfect_ten', 'read_10'),
('Literary Legend', 'Twenty books! You''ve officially achieved legend status in the ShineShelf community.', 'badge_legend', 'read_20');
