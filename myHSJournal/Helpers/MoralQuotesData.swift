//
//  MoralQuotesData.swift
//  myHSJournal
//
//  Created by Simone Karani on 2/21/21.
//  Copyright © 2021 Simone Karani. All rights reserved.
//

import Foundation

struct MoralQuote {
    var quoteId: Int = 0
    var quote: String?
    var author: String?
}

class MoralQuoteData {
    var moralQuoteList: [MoralQuote] = []
    
    init() {
        moralQuoteList.append(MoralQuote(quoteId: 1, quote: "Failure will never overtake me if my determination to succeed is strong enough.", author: "Og Mandino"))
        moralQuoteList.append(MoralQuote(quoteId: 2, quote: "If you want to achieve excellence, you can get there today. As of this second, quit doing less-than-excellent work.", author: "Thomas J. Watson"))
        moralQuoteList.append(MoralQuote(quoteId: 3, quote: "Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle. As with all matters of the heart, you'll know when you find it.", author: "Steve Jobs"))
        moralQuoteList.append(MoralQuote(quoteId: 4, quote: "When you're different, sometimes you don't see the millions of people who accept you for what you are. All you notice is the person who doesn't.", author: "Jodi Picoult"))
        moralQuoteList.append(MoralQuote(quoteId: 5, quote: "You may only succeed if you desire succeeding; you may only fail if you do not mind failing.", author: "Philippos"))
        moralQuoteList.append(MoralQuote(quoteId: 6, quote: "People who succeed have momentum. The more they succeed, the more they want to succeed, and the more they find a way to succeed. Similarly, when someone is failing, the tendency is to get on a downward spiral that can even become a self-fulfilling prophecy.", author: "Tony Robbins"))
        moralQuoteList.append(MoralQuote(quoteId: 7, quote: "Develop success from failures. Discouragement and failure are two of the surest stepping stones to success.", author: "Dale Carnegie"))
        moralQuoteList.append(MoralQuote(quoteId: 8, quote: "To be successful you must accept all challenges that come your way. You can’t just accept the ones you like.", author: "Mike Gafka"))
        moralQuoteList.append(MoralQuote(quoteId: 9, quote: "Success doesn’t come to you, you’ve got to go to it.", author: "Marva Collins"))
        moralQuoteList.append(MoralQuote(quoteId: 10, quote: "Keep on going, and the chances are that you will stumble on something, perhaps when you are least expecting it. I never heard of anyone ever stumbling on something sitting down.", author: "Charles F. Kettering"))
        moralQuoteList.append(MoralQuote(quoteId: 11, quote: "Successful and unsuccessful people do not vary greatly in their abilities. They vary in their desires to reach their potential.", author: "John Maxwell"))
        moralQuoteList.append(MoralQuote(quoteId: 12, quote: "I hear, and I forget. I see, and I remember. I do, and I understand.", author: "Chinese Proverb"))
        moralQuoteList.append(MoralQuote(quoteId: 13, quote: "Success means having the courage, the determination, and the will to become the person you believe you were meant to be.", author: "George Sheehan"))
        moralQuoteList.append(MoralQuote(quoteId: 14, quote: "Aim for success, not perfection. Never give up your right to be wrong, because then you will lose the ability to learn new things and move forward with your life. Remember that fear always lurks behind perfectionism.", author: "Dr. David M. Burns"))
        moralQuoteList.append(MoralQuote(quoteId: 15, quote: "Success is no accident. It is hard work, perseverance, learning, studying, sacrifice, and most of all, love of what you are doing or learning to do.", author: "Pele"))
        moralQuoteList.append(MoralQuote(quoteId: 16, quote: "Coming together is a beginning; keeping together is progress; working together is success.", author: "Edward Everett Hale"))
        moralQuoteList.append(MoralQuote(quoteId: 17, quote: "Self-belief and hard work will always earn you success.", author: "Virat Kohli"))
        moralQuoteList.append(MoralQuote(quoteId: 18, quote: "The secret of your success is determined by your daily agenda.", author: "John C. Maxwell"))
        moralQuoteList.append(MoralQuote(quoteId: 19, quote: "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.", author: "Christian D. Larson"))
        moralQuoteList.append(MoralQuote(quoteId: 20, quote: "If you want to succeed as much as you want to breathe, then you will be successful.", author: "Eric Thomas"))
        moralQuoteList.append(MoralQuote(quoteId: 21, quote: "It's not whether you get knocked down, it's whether you get back up.", author: "Vince Lombardi"))
        moralQuoteList.append(MoralQuote(quoteId: 22, quote: "Don’t let what you cannot do interfere with what you can do.", author: "John Wooden"))
        moralQuoteList.append(MoralQuote(quoteId: 23, quote: "Would you like me to give you a formula for success? It's quite simple, really: Double your rate of failure. You are thinking of failure as the enemy of success. But it isn't at all. You can be discouraged by failure or you can learn from it, so go ahead and make mistakes. Make all you can. Because remember that's where you will find success.", author: "Thomas J. Watson"))
        moralQuoteList.append(MoralQuote(quoteId: 24, quote: "Successful people do what unsuccessful people are not willing to do. Don't wish it were easier; wish you were better.", author: "Jim Rohn"))
        moralQuoteList.append(MoralQuote(quoteId: 25, quote: "The difference between a successful person and others is not a lack of strength, not a lack of knowledge, but rather a lack in will.", author: "Vince Lombardi"))
        moralQuoteList.append(MoralQuote(quoteId: 26, quote: "The way to get started is to quit talking and begin doing.", author: "Walt Disney"))
        moralQuoteList.append(MoralQuote(quoteId: 27, quote: "If you can't fly, then run. If you can't run, then walk. If you can't walk, then crawl, but whatever you do, you have to keep moving forward.", author: "Martin Luther King, Jr."))
        moralQuoteList.append(MoralQuote(quoteId: 28, quote: "If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success.", author: "James Cameron"))
        moralQuoteList.append(MoralQuote(quoteId: 29, quote: "The successful warrior is the average man, with laser-like focus.", author: "Bruce Lee"))
        moralQuoteList.append(MoralQuote(quoteId: 30, quote: "Education is the passport to the future, for tomorrow belongs to those who prepare for it today.", author: "Malcolm X"))
        moralQuoteList.append(MoralQuote(quoteId: 31, quote: "I've failed over and over and over in my life and that is why I succeed.", author: "Michael Jordan"))
        moralQuoteList.append(MoralQuote(quoteId: 32, quote: "There will be doubters, there will be obstacles, there will be mistakes. But, with hard work, there are no limits.", author: "Michael Phelps"))
        moralQuoteList.append(MoralQuote(quoteId: 33, quote: "Optimism is the faith that leads to achievement. Nothing can be done without hope and confidence.", author: "Helen Keller"))
        moralQuoteList.append(MoralQuote(quoteId: 34, quote: "Action is the foundational key to all success.", author: "Pablo Picasso"))
        moralQuoteList.append(MoralQuote(quoteId: 35, quote: "You just can’t beat the person who never gives up.", author: "Babe Ruth"))
        moralQuoteList.append(MoralQuote(quoteId: 36, quote: "Success is most often achieved by those who don't know that failure is inevitable.", author: "Coco Chanel"))
        moralQuoteList.append(MoralQuote(quoteId: 37, quote: "Take up one idea. Make that one idea your life — think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body be full of that idea, and just leave every other idea alone. This is the way to success.", author: "Swami Vivekananda"))
        moralQuoteList.append(MoralQuote(quoteId: 38, quote: "A successful man is one who can lay a firm foundation with the bricks others have thrown at him.", author: "David Brinkley"))
        moralQuoteList.append(MoralQuote(quoteId: 39, quote: "Failure is another stepping stone to greatness.", author: "Oprah Winfrey"))
        moralQuoteList.append(MoralQuote(quoteId: 40, quote: "You miss 100 percent of the shots you don't take.", author: "Wayne Gretzky"))
        moralQuoteList.append(MoralQuote(quoteId: 41, quote: "Don't limit yourself. Many people limit themselves to what they think they can do. You can go as far as your mind lets you. What you believe, remember, you can achieve.", author: "Mary Kay Ash"))
        moralQuoteList.append(MoralQuote(quoteId: 42, quote: "Success is the sum of small efforts, repeated day-in and day-out.", author: "Robert Collier"))
        moralQuoteList.append(MoralQuote(quoteId: 43, quote: "The biggest risk is not taking any risk… In a world that's changing really quickly, the only strategy that is guaranteed to fail is not taking risks.", author: "Mark Zuckerberg"))
        moralQuoteList.append(MoralQuote(quoteId: 44, quote: "Don't be afraid to give up the good to go for the great.", author: "John D. Rockefeller"))
        moralQuoteList.append(MoralQuote(quoteId: 45, quote: "Though no one can go back and make a brand-new start, anyone can start from now and make a brand-new ending.", author: "Carl Bard"))
        moralQuoteList.append(MoralQuote(quoteId: 46, quote: "Our greatest fear should not be of failure… but of succeeding at things in life that don't really matter.", author: "Francis Chan"))
        moralQuoteList.append(MoralQuote(quoteId: 47, quote: "If you don't design your own life plan, chances are you'll fall into someone else's plan. And guess what they have planned for you? Not much.", author: "Jim Rohn"))
        moralQuoteList.append(MoralQuote(quoteId: 48, quote: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius"))
        moralQuoteList.append(MoralQuote(quoteId: 49, quote: "It always seems impossible until it’s done.", author: "Nelson Mandela"))
        moralQuoteList.append(MoralQuote(quoteId: 50, quote: "We may encounter many defeats but we must not be defeated.", author: "Maya Angelou"))
        moralQuoteList.append(MoralQuote(quoteId: 51, quote: "Knowing is not enough; we must apply. Wishing is not enough; we must do.", author: "Johann Wolfgang Von Goethe"))
        moralQuoteList.append(MoralQuote(quoteId: 52, quote: "Reading is to the mind, as exercise is to the body.", author: "Brian Tracy"))
        moralQuoteList.append(MoralQuote(quoteId: 53, quote: "If you can’t explain it simply, you don’t understand it well enough.", author: "Albert Einstein"))
        moralQuoteList.append(MoralQuote(quoteId: 54, quote: "Failure is the opportunity to begin again more intelligently.", author: "Henry Ford"))
        moralQuoteList.append(MoralQuote(quoteId: 55, quote: "Preparation is the key to success.", author: "Alexander Graham Bell"))
        moralQuoteList.append(MoralQuote(quoteId: 56, quote: "Who questions much, shall learn much, and retain much.", author: "Francis Bacon"))
        moralQuoteList.append(MoralQuote(quoteId: 57, quote: "Procrastination is the art of keeping up with yesterday.", author: "Don Marquis"))
        moralQuoteList.append(MoralQuote(quoteId: 58, quote: "Ninety-nine percent of the failures come from people who have the habit of making excuses.", author: "George Washington Carver"))
        moralQuoteList.append(MoralQuote(quoteId: 59, quote: "However difficult life may seem, there is always something you can do and succeed at.", author: "Stephen Hawking"))
        moralQuoteList.append(MoralQuote(quoteId: 60, quote: "I find that the harder I work, the more luck I seem to have.", author: "Thomas Jefferson"))
        moralQuoteList.append(MoralQuote(quoteId: 61, quote: "Perseverance is the hard work you do after you get tired of doing the hard work you already did.", author: "Newt Gingrich"))
        moralQuoteList.append(MoralQuote(quoteId: 62, quote: "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You have to keep going.", author: "Chantal Sutherland"))
        moralQuoteList.append(MoralQuote(quoteId: 63, quote: "There are no traffic jams on the extra mile.", author: "Zig Ziglar"))
        moralQuoteList.append(MoralQuote(quoteId: 64, quote: "Work gives you meaning and purpose and life is empty without it.", author: "Stephen Hawking"))
        moralQuoteList.append(MoralQuote(quoteId: 65, quote: "Nobody can go back and start a new beginning, but anyone can start today and make a new ending.", author: "Maria Robinson"))
        moralQuoteList.append(MoralQuote(quoteId: 66, quote: "Live as if you were to die tomorrow. Learn as if you were to live forever.", author: "Mahatma Gandhi"))
        moralQuoteList.append(MoralQuote(quoteId: 67, quote: "Genius is 1% inspiration and 99% perspiration. Accordingly, a genius is often merely a talented person who has done all of his or her homework.", author: "Anonymous"))
        moralQuoteList.append(MoralQuote(quoteId: 68, quote: "Work as hard as you can and then be happy in the knowledge you couldn’t have done any more.", author: "Unknown"))
        moralQuoteList.append(MoralQuote(quoteId: 69, quote: "Today a reader. Tomorrow a leader.", author: "Anonymous"))
        moralQuoteList.append(MoralQuote(quoteId: 70, quote: "If people only knew how hard I’ve worked to gain my mastery, it wouldn’t seem so wonderful at all.", author: "Michelangelo"))
        moralQuoteList.append(MoralQuote(quoteId: 71, quote: "Discovery consists of seeing what everybody has seen and thinking what nobody has thought.", author: "Albert Szent-Gyorgyi"))
        moralQuoteList.append(MoralQuote(quoteId: 72, quote: "Be stronger than your excuses.", author: "Anonymous"))
        moralQuoteList.append(MoralQuote(quoteId: 73, quote: "You don’t have to be great to start, but you have to start to be great.", author: "Zig Ziglar"))
        moralQuoteList.append(MoralQuote(quoteId: 74, quote: "The future belongs to the competent. Get good, get better, be the best!", author: "Brian Tracy"))
        moralQuoteList.append(MoralQuote(quoteId: 75, quote: "Aim for success, not perfection. Never give up your right to be wrong, because then you will lose the ability to learn new things and move forward with your life. Remember that fear always lurks behind perfectionism.", author: "David M. Burns"))
        moralQuoteList.append(MoralQuote(quoteId: 76, quote: "Whether you think you can or think you can’t, you’re right.", author: "Henry Ford"))
        moralQuoteList.append(MoralQuote(quoteId: 77, quote: "Thinking should become your capital asset, no matter whatever ups and downs you come across in your life.", author: "Dr. APJ Kalam"))
        moralQuoteList.append(MoralQuote(quoteId: 78, quote: "You’ve got to get up every morning with determination if you’re going to go to bed with satisfaction.", author: "George Lorimer"))
        moralQuoteList.append(MoralQuote(quoteId: 79, quote: "The expert in anything was once a beginner.", author: "Helen Hayes"))
        moralQuoteList.append(MoralQuote(quoteId: 80, quote: "There are no secrets to success. It is the result of preparation, hard work, and learning from failure.", author: "Colin Powell"))
        moralQuoteList.append(MoralQuote(quoteId: 81, quote: "The beautiful thing about learning is that no one can take it away from you.", author: "B.B. King"))
        moralQuoteList.append(MoralQuote(quoteId: 82, quote: "We learn more by looking for the answer to a question and not finding it than we do from learning the answer itself.", author: "Lloyd Alexander"))
    }
    
    func getMoralQuote() -> MoralQuote {
        return moralQuoteList.randomElement()!
    }
}
